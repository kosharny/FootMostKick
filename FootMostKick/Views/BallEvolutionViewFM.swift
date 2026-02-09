import SwiftUI

struct BallEvolutionViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    let evolutionStages = [
        (year: "1930", title: "The Leather Era", description: "Heavy, water-absorbing leather balls with laces. Inconsistent flight and painful to head.", icon: "circle.grid.hex"),
        (year: "1970", title: "The Telstar", description: "The iconic 32-panel black and white design introduced for TV visibility.", icon: "soccerball"),
        (year: "2006", title: "Teamgeist", description: "Fewer panels (14) for a smoother surface and better control.", icon: "circle.circle"),
        (year: "2010", title: "Jabulani", description: "Notorious for its unpredictable flight path due to extreme roundness.", icon: "tornado"),
        (year: "2024", title: "Modern Tech", description: "Thermally bonded, textured surface for perfect aerodynamics and grip.", icon: "soccerball.inverse")
    ]
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
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
                    
                    Text("Ball Evolution")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(viewModel.currentTheme.primaryColor.ignoresSafeArea(edges: .top))
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(evolutionStages.enumerated()), id: \.offset) { index, stage in
                            timelineRow(stage: stage, isLast: index == evolutionStages.count - 1)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .onAppear { viewModel.showTabBar = false }
        .onDisappear { viewModel.showTabBar = true }
    }
    
    private func timelineRow(stage: (year: String, title: String, description: String, icon: String), isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 20) {
            // Timeline Line and Dot
            VStack(spacing: 0) {
                Circle()
                    .fill(viewModel.currentTheme.accentColor)
                    .frame(width: 12, height: 12)
                    .padding(.top, 6)
                
                if !isLast {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 2)
                        .frame(minHeight: 100)
                }
            }
            .frame(width: 20)
            
            // Content
            AppCardFM {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(stage.year)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(viewModel.currentTheme.accentColor)
                        
                        Spacer()
                        
                        Image(systemName: stage.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Text(stage.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(stage.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(4)
                }
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    BallEvolutionViewFM()
        .environmentObject(MainViewModelFM())
}
