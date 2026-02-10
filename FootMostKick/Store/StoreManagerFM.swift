import Combine
import StoreKit
import SwiftUI

@MainActor
final class StoreManagerFM: ObservableObject {
    static let shared = StoreManagerFM()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false
    
    private let productIDs: Set<String> = [
        "premium_theme_ocean_breeze",
        "premium_theme_midnight_sky"
    ]
    
    init() {
        Task {
            await fetchProducts()
            await updatePurchasedProducts()
            await observeTransactions()
        }
    }
    
    func fetchProducts() async {
        isLoading = true
        
        do {
            let fetchedProducts = try await Product.products(for: productIDs)
            self.products = fetchedProducts
            
            if fetchedProducts.isEmpty {
                print("⚠️ StoreKit returned no products. Check .storekit configuration.")
            }
            
        } catch {
            print("❌ Failed to fetch products: \(error)")
        }
        
        isLoading = false
    }
    
    func purchase(_ product: Product) async -> PurchaseStatus {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                purchasedProductIDs.insert(transaction.productID)
                
                await transaction.finish()
                
                return .success
                
            case .userCancelled:
                return .cancelled
                
            case .pending:
                return .pending
                
            @unknown default:
                return .failed
            }
        } catch {
            print("Purchase failed:", error)
            return .failed
        }
    }
    
    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }
    
    private func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }
    
    private func observeTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue,
                                      shouldAddStorePayment payment: SKPayment,
                                      for product: SKProduct) -> Bool {
            return true
        }
}

extension StoreManagerFM {
    func hasAccess(to theme: ThemeFM) -> Bool {
        guard theme.isPremium else { return true }
        guard let productID = theme.productId else { return false }
        return purchasedProductIDs.contains(productID)
    }
}

enum StoreError: Error {
    case failedVerification
}

enum PurchaseStatus {
    case success
    case pending
    case cancelled
    case failed
}
    
