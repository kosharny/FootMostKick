import SwiftUI

struct CustomTabBarFM: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var viewModel: MainViewModelFM
    
    private let tabs = [
        (image: "house.fill", title: "Home"),
        (image: "book.fill", title: "Journal"),
        (image: "magnifyingglass", title: "Search"),
        (image: "heart.fill", title: "Favorites"),
        (image: "chart.bar.fill", title: "Stats")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].image)
                            .font(.system(size: 20, weight: .semibold))
                            .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                        
                        // Optional: Show text only for selected or all? 
                        // Staying clean with just icons mainly, or small text if needed. 
                        // Let's keep it icon-focused for the capsule look.
                    }
                    .foregroundColor(selectedTab == index ? viewModel.currentTheme.accentColor : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8) // Reduced from 10
        .background(Color.black.opacity(0.8))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.blue, lineWidth: 2)
        )
        .padding(.horizontal, 40) // Increased horizontal padding to make it smaller width-wise
        .padding(.bottom, 0) // Remove extra bottom lifting, let ZStack align it or use minimal
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    CustomTabBarFM(selectedTab: .constant(0))
        .environmentObject(MainViewModelFM())
        .background(Color.gray)
}
