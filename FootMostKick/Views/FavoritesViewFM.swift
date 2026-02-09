import SwiftUI

struct FavoritesViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @State private var selectedSegment = 0
    
    var favoriteArticles: [ArticleFM] {
        viewModel.articles.filter { viewModel.favoriteArticleIDs.contains($0.id) }
    }
    
    var favoriteTasks: [TaskFM] {
        viewModel.tasks.filter { viewModel.favoriteTaskIDs.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFM(title: "Favorites")
                    
                    segmentControl
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            if selectedSegment == 0 {
                                if favoriteTasks.isEmpty {
                                    emptyState(text: "No favorite tasks yet")
                                } else {
                                    tasksList
                                }
                            } else {
                                if favoriteArticles.isEmpty {
                                    emptyState(text: "No favorite articles yet")
                                } else {
                                    articlesList
                                }
                            }
                            
                            Color.clear.frame(height: 80)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var segmentControl: some View {
        HStack(spacing: 0) {
            Button(action: { withAnimation { selectedSegment = 0 } }) {
                Text("Tasks")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedSegment == 0 ? viewModel.currentTheme.primaryColor : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedSegment == 0 ? Color.white : Color.clear)
            }
            .cornerRadius(12, corners: [.topLeft, .bottomLeft])
            
            Button(action: { withAnimation { selectedSegment = 1 } }) {
                Text("Articles")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(selectedSegment == 1 ? viewModel.currentTheme.primaryColor : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedSegment == 1 ? Color.white : Color.clear)
            }
            .cornerRadius(12, corners: [.topRight, .bottomRight])
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .padding(20)
    }
    
    private var tasksList: some View {
        ForEach(favoriteTasks) { task in
            NavigationLink(destination: DetailsViewFM(task: task).navigationBarHidden(true)) {
                AppCardFM(padding: 0) {
                    HStack(spacing: 0) {
                        Image(task.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(task.title)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.toggleFavoriteTask(task.id)
                                }) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                }
                            }
                            
                            HStack {
                                Text("\(task.duration) min")
                                Spacer()
                                Text(task.difficulty)
                            }
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(12)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var articlesList: some View {
        ForEach(favoriteArticles) { article in
            NavigationLink(destination: DetailsViewFM(article: article).navigationBarHidden(true)) {
                AppCardFM(padding: 0) {
                    HStack(spacing: 0) {
                        Image(article.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(article.title)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.toggleFavoriteArticle(article.id)
                                }) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                }
                            }
                            
                            HStack {
                                Text("\(article.readTime) min read")
                                Spacer()
                                Text(article.category)
                            }
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(12)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func emptyState(text: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
                .padding(.top, 60)
            
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    FavoritesViewFM()
        .environmentObject(MainViewModelFM())
}
