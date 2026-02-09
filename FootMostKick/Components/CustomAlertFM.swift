import SwiftUI

struct CustomAlertFM: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    var secondaryButtonTitle: String? = nil
    var secondaryAction: (() -> Void)? = nil
    
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var body: some View {
        ZStack {
            // Background dimming
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    if secondaryButtonTitle != nil {
                        secondaryAction?()
                    }
                }
            
            VStack {
                AppCardFM {
                    VStack(spacing: 20) {
                        // Title
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        // Message
                        Text(message)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Buttons
                        HStack(spacing: 12) {
                            if let secondaryTitle = secondaryButtonTitle {
                                Button(action: { secondaryAction?() }) {
                                    Text(secondaryTitle)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                            
                            Button(action: { primaryAction() }) {
                                Text(primaryButtonTitle)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(viewModel.currentTheme.primaryColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(viewModel.currentTheme.accentColor)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(8) // Extra internal padding for the content
                }
                .frame(maxWidth: 320)
                .padding(24)
            }
        }
    }
}

#Preview {
    CustomAlertFM(
        title: "Complete Purchase",
        message: "Would you like to purchase Ocean Breeze for $0.99?",
        primaryButtonTitle: "Yes",
        primaryAction: {},
        secondaryButtonTitle: "No",
        secondaryAction: {}
    )
    .environmentObject(MainViewModelFM())
}
