import SwiftUI

struct AppCardFM<Content: View>: View {
    let content: Content
    var onTap: (() -> Void)? = nil
    var padding: CGFloat = 16
    @EnvironmentObject var viewModel: MainViewModelFM
    
    init(padding: CGFloat = 16, onTap: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.onTap = onTap
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        if let onTap = onTap {
            Button(action: onTap) {
                cardContent
            }
            .buttonStyle(ScaleButtonStyle())
        } else {
            cardContent
        }
    }
    
    private var cardContent: some View {
        content
            .padding(padding)
            .background(
                viewModel.currentTheme.cardBackground
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    AppCardFM {
        Text("Sample Card")
            .foregroundColor(.white)
            .frame(width: 200, height: 100)
    }
    .padding()
    .background(Color.black)
    .environmentObject(MainViewModelFM())
}
