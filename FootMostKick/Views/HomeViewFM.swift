import SwiftUI

struct HomeViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    CustomHeaderFM(title: "FootMost Kick")
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            // Position Quiz Card
                            positionQuizCard
                            
                            // Featured Section
                            featuredSection
                            
                            // Evolution Infographic (New)
                            evolutionInfographic
                            
                            // Recent Progress
                            progressSection
                            
                            // Shot Types (New)
                            shotTypesSection
                            
                            // Daily Tips
                            tipsSection
                            
                            // Spacer for TabBar
                            Color.clear.frame(height: 80)
                        }
                        .padding(.vertical, 20)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var positionQuizCard: some View {
        NavigationLink(destination: PositionQuizViewFM()) {
            AppCardFM {
                HStack(spacing: 20) {
                    if let position = viewModel.userPosition {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Perfect Position")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text(position)
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(.white)
                            
                            Text("Tap to retake the test")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        
                        Spacer()
                        
                        Image(positionAsset(position))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 90)
                            .cornerRadius(16)
                            .clipped()
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Find Your Role")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Take the test to discover which football position suits you best.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        
                        Image("quiz_initial")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(16)
                            .clipped()
                    }
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func positionAsset(_ position: String) -> String {
        switch position {
        case "Forward": return "quiz_forward"
        case "Midfielder": return "quiz_midfielder"
        case "Defender": return "quiz_defender"
        case "Goalkeeper": return "quiz_goalkeeper"
        default: return "quiz_initial"
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Training")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.tasks.prefix(5)) { task in
                        NavigationLink(destination: DetailsViewFM(task: task).navigationBarHidden(true)) {
                            AppCardFM(padding: 0) { // Now defaults to View, effectively just a container
                                VStack(alignment: .leading, spacing: 0) {
                                    Image(task.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 100)
                                        .clipped()
                                    Spacer()
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(task.difficulty)
                                                .font(.system(size: 10, weight: .bold))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(viewModel.currentTheme.accentColor.opacity(0.2))
                                                .foregroundColor(viewModel.currentTheme.accentColor)
                                                .cornerRadius(4)
                                            
                                            Spacer()
                                            
                                            if viewModel.completedTaskIDs.contains(task.id) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 14))
                                            }
                                        }
                                        
                                        Text(task.title)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("\(task.duration) min")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    .padding(12)
                                }
                                .frame(width: 160, height: 200)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var evolutionInfographic: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ball Evolution")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            NavigationLink(destination: BallEvolutionViewFM().navigationBarHidden(true)) {
                AppCardFM {
                    VStack(spacing: 20) {
                        HStack(alignment: .bottom, spacing: 0) {
                            evolutionStep(year: "1930", icon: "circle.grid.hex", label: "Leather")
                            evolutionLine
                            evolutionStep(year: "1970", icon: "soccerball", label: "Telstar")
                            evolutionLine
                            evolutionStep(year: "2024", icon: "soccerball.inverse", label: "Hi-Tech")
                        }
                        .padding(.top, 10)
                        
                        Text("Tap to view full history")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(viewModel.currentTheme.accentColor)
                            .padding(.top, 4)
                    }
                    .padding(10)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func evolutionStep(year: String, icon: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(viewModel.currentTheme.accentColor)
            Text(year)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var evolutionLine: some View {
        Rectangle()
            .fill(Color.white.opacity(0.2))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 25)
    }
    
    private var shotTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Master Your Shots")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    shotBlock(name: "Knuckleball", icon: "wind")
                    shotBlock(name: "Curved", icon: "arrow.uturn.right")
                    shotBlock(name: "Power", icon: "bolt.fill")
                    shotBlock(name: "Chip", icon: "arrow.up.right")
                    shotBlock(name: "Volley", icon: "figure.soccer")
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func shotBlock(name: String, icon: String) -> some View {
        NavigationLink(destination: ShotDetailViewFM(selectedShotName: name).navigationBarHidden(true)) {
            VStack(spacing: 12) {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.currentTheme.accentColor)
                    )
                
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 90)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            AppCardFM {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.completedTasksCount)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(viewModel.currentTheme.accentColor)
                        Text("Tasks Done")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(viewModel.readArticlesCount)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(viewModel.currentTheme.accentColor)
                        Text("Articles Read")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    CircularProgressView(progress: viewModel.progressPercentage)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Tips")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ForEach(viewModel.articles.prefix(3)) { article in
                NavigationLink(destination: DetailsViewFM(article: article).navigationBarHidden(true)) {
                    AppCardFM {
                        HStack(spacing: 16) {
                            Image(article.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 70)
                                .cornerRadius(12)
                                .clipped()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                Text("\(article.readTime) min read")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    HomeViewFM()
        .environmentObject(MainViewModelFM())
}
