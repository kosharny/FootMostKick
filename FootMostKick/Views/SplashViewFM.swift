import SwiftUI

struct SplashViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @State private var isActive = false
    @State private var scale = 0.8
    @State private var opacity = 0.0
    
    @State private var shimmerPos: CGFloat = -1.5
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 4)
                        .frame(width: 210, height: 210)
                    
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                }
                .overlay(shimmerStreak().mask(Circle().frame(width: 200)))
                
                Text("FootMost Kick")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .overlay(
                        shimmerStreak()
                            .mask(Text("FootMost Kick").font(.system(size: 33, weight: .bold, design: .rounded)).padding(.top, 20))
                    )
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                shimmerPos = 1.5
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    viewModel.showSplash = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func shimmerStreak() -> some View {
        GeometryReader { geo in
            let width = geo.size.width
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.4),
                    .init(color: .white.opacity(0.7), location: 0.5), // Самая яркая точка блика
                    .init(color: .clear, location: 0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: width * 1.5)
            .offset(x: shimmerPos * width)
        }
    }
}

#Preview {
    SplashViewFM()
        .environmentObject(MainViewModelFM())
}
