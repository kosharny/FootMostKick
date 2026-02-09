import SwiftUI

struct MainViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var body: some View {
        Group {
            if viewModel.showSplash {
                SplashViewFM()
            } else if !viewModel.hasCompletedOnboarding {
                OnboardingViewFM()
            } else {
                ZStack(alignment: .bottom) {
                    TabView(selection: $viewModel.selectedTab) {
                        HomeViewFM()
                            .tag(0)
                        
                        JournalViewFM()
                            .tag(1)
                        
                        SearchViewFM()
                            .tag(2)
                        
                        FavoritesViewFM()
                            .tag(3)
                            
                        StatViewFM()
                            .tag(4)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never)) // Swipeable tabs
                    .ignoresSafeArea()
                    
                    if viewModel.showTabBar {
                        CustomTabBarFM(selectedTab: $viewModel.selectedTab)
                            .padding(.bottom, 10) // Lift from safe area
                    }
                }
                .background(viewModel.currentTheme.backgroundColor.ignoresSafeArea())
            }
        }
        .animation(.default, value: viewModel.showSplash)
        .animation(.default, value: viewModel.hasCompletedOnboarding)
    }
}

#Preview {
    MainViewFM()
        .environmentObject(MainViewModelFM())
}
