import SwiftUI
import StoreKit

struct SettingsViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var store = StoreManagerFM.shared
    @State private var selectedThemeForPaywall: ThemeFM?
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Theme Section
                        themeSection
                        
                        // Premium Section
                        premiumSection
                        
                        // General Section
                        generalSection
                    }
                    .padding(20)
                }
            }
        }
        .sheet(item: $selectedThemeForPaywall) { theme in
            PaywallViewFM(theme: theme)
                .environmentObject(viewModel)
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("Settings")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Balance spacing
            Button(action: {}) {
                Text("Back")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.clear)
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(viewModel.currentTheme.primaryColor.ignoresSafeArea(edges: .top))
    }
    
    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Appearance")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            ForEach(viewModel.themes) { theme in
                let hasAccess = store.hasAccess(to: theme)
                let product = store.products.first(where: { $0.id == theme.productId })
                
                Button(action: {
                    if hasAccess {
                        viewModel.selectTheme(theme)
                    } else {
                        selectedThemeForPaywall = theme
                    }
                }) {
                    HStack {
                        Circle()
                            .fill(themeColor(for: theme.id))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                        
                        Text(theme.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if theme.isPremium && !hasAccess {
                            HStack(spacing: 4) {
                                Text(product?.displayPrice ?? (theme.price ?? ""))
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.system(size: 12))
                                
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))
                            }
                        } else if viewModel.selectedThemeID == theme.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var premiumSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Button(action: {
                Task {
                    await store.restorePurchases()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise.circle.fill")
                    Text("Restore Purchases")
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
            }
        }
    }
    
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("General")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            NavigationLink(destination: AboutViewFM().navigationBarHidden(true)) {
                HStack {
                    Image(systemName: "info.circle.fill")
                    Text("About App")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
            }
        }
    }
    
    private func themeColor(for id: String) -> Color {
        switch id {
        case "ocean": return .blue
        case "midnight": return .black
        default: return Color(red: 0.1, green: 0.2, blue: 0.5)
        }
    }
}

#Preview {
    SettingsViewFM()
        .environmentObject(MainViewModelFM())
}
