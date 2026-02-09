import SwiftUI

struct OnboardingViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @State private var currentPage = 0
    
    let pages = [
        (image: "onboarding_1", title: "Master Your Kick", description: "Learn professional football kicking techniques step by step. From power shots to delicate chips."),
        (image: "onboarding_2", title: "Track Progress", description: "Keep a journal of your training sessions. Monitor your improvement over time with detailed stats."),
        (image: "onboarding_3", title: "Become a Pro", description: "Unlock premium content and advanced techniques to take your game to the next level.")
    ]
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        viewModel.completeOnboarding()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Image(pages[index].image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 220)
                                .cornerRadius(32)
                                .clipped()
                                .shadow(color: viewModel.currentTheme.accentColor.opacity(0.3), radius: 15)
                            
                            VStack(spacing: 16) {
                                Text(pages[index].title)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text(pages[index].description)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 30)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 450)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? viewModel.currentTheme.accentColor : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(viewModel.currentTheme.primaryColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                Spacer(minLength: 100)
            }
        }
    }
}

#Preview {
    OnboardingViewFM()
        .environmentObject(MainViewModelFM())
}
