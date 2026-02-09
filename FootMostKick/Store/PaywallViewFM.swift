import SwiftUI
import StoreKit

struct PaywallViewFM: View {
    let theme: ThemeFM
    
    @StateObject private var store = StoreManagerFM.shared
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.dismiss) var dismiss
    
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    @State private var resultTitle = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Close Button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(20)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Theme Preview Header
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.currentTheme.accentColor.opacity(0.2))
                                    .frame(width: 140, height: 140)
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(viewModel.currentTheme.accentColor)
                                    .shadow(color: viewModel.currentTheme.accentColor.opacity(0.5), radius: 10)
                            }
                            
                            VStack(spacing: 8) {
                                Text("PREMIUM THEME")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(viewModel.currentTheme.accentColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(viewModel.currentTheme.accentColor.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Text(theme.name)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Features List
                        VStack(spacing: 16) {
                            StoreFeatureRow(
                                icon: "paintpalette.fill",
                                title: "Exclusive Design",
                                description: "Transform your app with unique colors and styles.",
                                accentColor: viewModel.currentTheme.accentColor
                            )
                            
                            StoreFeatureRow(
                                icon: "sparkles",
                                title: "Premium Accents",
                                description: "Special visual effects for a pro-level experience.",
                                accentColor: viewModel.currentTheme.accentColor
                            )
                            
                            StoreFeatureRow(
                                icon: "bolt.fill",
                                title: "Immediate Access",
                                description: "Unlock forever with a single one-time purchase.",
                                accentColor: viewModel.currentTheme.accentColor
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Purchase Button Section
                        if let product = store.products.first(where: { $0.id == theme.productId }) {
                            VStack(spacing: 16) {
                                Button(action: {
                                    selectedProduct = product
                                    showConfirmAlert = true
                                }) {
                                    HStack {
                                        Text("Unlock for \(product.displayPrice)")
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                    .foregroundColor(viewModel.currentTheme.primaryColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(viewModel.currentTheme.accentColor)
                                    .cornerRadius(16)
                                    .shadow(color: viewModel.currentTheme.accentColor.opacity(0.3), radius: 8)
                                    .padding(.horizontal)
                                }
                                
                                Button(action: {
                                    Task {
                                        await store.restorePurchases()
                                        if store.hasAccess(to: theme) {
                                            showAlert(title: "Success", message: "Your purchases have been restored successfully!")
                                            isSuccess = true
                                        } else {
                                            showAlert(title: "No Purchases", message: "We couldn't find any previous purchases for this theme.")
                                        }
                                    }
                                }) {
                                    Text("Restore Purchases")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(viewModel.currentTheme.accentColor)
                                }
                            }
                        } else {
                            VStack(spacing: 12) {
                                if store.isLoading {
                                    ProgressView()
                                        .tint(viewModel.currentTheme.accentColor)
                                } else {
                                    Text("Product details currently unavailable")
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Button("Try Again") {
                                        Task { await store.fetchProducts() }
                                    }
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(viewModel.currentTheme.accentColor)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .overlay {
            if showConfirmAlert {
                CustomAlertFM(
                    title: "Complete Purchase",
                    message: "Would you like to purchase \(theme.name) for \(selectedProduct?.displayPrice ?? "...")?",
                    primaryButtonTitle: "Yes",
                    primaryAction: {
                        showConfirmAlert = false
                        Task { await performPurchase() }
                    },
                    secondaryButtonTitle: "No",
                    secondaryAction: {
                        showConfirmAlert = false
                    }
                )
                .transition(.opacity.combined(with: .scale))
            }
            
            if showResultAlert {
                CustomAlertFM(
                    title: resultTitle,
                    message: resultMessage,
                    primaryButtonTitle: "OK",
                    primaryAction: {
                        showResultAlert = false
                        if isSuccess { dismiss() }
                    }
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.1), value: showConfirmAlert)
        .animation(.easeInOut(duration: 0.1), value: showResultAlert)
    }
    
    private func showAlert(title: String, message: String) {
        resultTitle = title
        resultMessage = message
        showResultAlert = true
    }
    
    private func performPurchase() async {
        guard let product = selectedProduct else { return }
        
        let status = await store.purchase(product)
        
        switch status {
        case .success:
            if store.hasAccess(to: theme) {
                isSuccess = true
                showAlert(title: "Success!", message: "\(theme.name) is now yours. Enjoy the new look!")
            }
        case .pending:
            showAlert(title: "Pending", message: "Your purchase is awaiting approval.")
        case .failed:
            showAlert(title: "Error", message: "Purchase failed. Please try again.")
        case .cancelled:
            break
        }
    }
}

struct StoreFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(accentColor)
                .frame(width: 44, height: 44)
                .background(accentColor.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}
