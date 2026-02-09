import SwiftUI

struct StatViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFM(title: "Statistics")
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            mainStatsGrid
                            
                            activityChart
                            
                            progressBars
                            
                            Color.clear.frame(height: 80)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var mainStatsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            statBox(
                title: "Tasks",
                value: "\(viewModel.completedTasksCount)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            statBox(
                title: "Articles",
                value: "\(viewModel.readArticlesCount)",
                icon: "book.fill",
                color: .blue
            )
            
            statBox(
                title: "Active Days",
                value: "\(viewModel.activeDaysCount)",
                icon: "calendar",
                color: .orange
            )
            
            statBox(
                title: "Streak",
                value: "3", // Placeholder for logic
                icon: "flame.fill",
                color: .red
            )
        }
        .padding(.horizontal, 20)
    }
    
    private func statBox(title: String, value: String, icon: String, color: Color) -> some View {
        AppCardFM {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                    Spacer()
                }
                
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
    
    private var activityChart: some View {
        AppCardFM {
            VStack(alignment: .leading, spacing: 16) {
                Text("Weekly Activity")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(0..<7) { _ in
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 4)
                                .fill(viewModel.currentTheme.accentColor)
                                .frame(height: CGFloat.random(in: 20...100))
                        }
                    }
                }
                .frame(height: 120)
                
                HStack {
                    ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var progressBars: some View {
        AppCardFM {
            VStack(alignment: .leading, spacing: 20) {
                Text("Skills Breakdown")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                skillBar(title: "Technique", progress: 0.6)
                skillBar(title: "Strategy", progress: 0.3)
                skillBar(title: "Fitness", progress: 0.45)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func skillBar(title: String, progress: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(viewModel.currentTheme.accentColor)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(viewModel.currentTheme.accentColor)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    StatViewFM()
        .environmentObject(MainViewModelFM())
}
