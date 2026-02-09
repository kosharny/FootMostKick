import SwiftUI

struct SearchViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @State private var showFilters = false
    
    let categories = ["All", "Technique", "Strategy", "Advanced", "Training", "Fundamentals", "Psychology", "Beginner", "Intermediate"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFM(title: "Search")
                    
                    searchBar
                    
                    categoryFilter
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            if viewModel.filteredArticles().isEmpty && viewModel.filteredTasks().isEmpty {
                                emptySearchState
                            } else {
                                if !viewModel.filteredTasks().isEmpty {
                                    tasksSection
                                }
                                
                                if !viewModel.filteredArticles().isEmpty {
                                    articlesSection
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
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.6))
            
            TextField("Search content...", text: $viewModel.searchQuery)
                .foregroundColor(.white)
                .accentColor(viewModel.currentTheme.accentColor)
            
            if !viewModel.searchQuery.isEmpty {
                Button(action: {
                    viewModel.searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedCategory = category
                        }
                    }) {
                        Text(category)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(viewModel.selectedCategory == category ? viewModel.currentTheme.primaryColor : .white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedCategory == category ? Color.white : Color.white.opacity(0.1)
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Training Tasks")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 20)
            
            ForEach(viewModel.filteredTasks()) { task in
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
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 8) {
                                        if viewModel.completedTaskIDs.contains(task.id) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.system(size: 12))
                                        }
                                        
                                        if viewModel.favoriteTaskIDs.contains(task.id) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 12))
                                        }
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
    }
    
    private var articlesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Articles")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 20)
            
            ForEach(viewModel.filteredArticles()) { article in
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
                                    
                                    Spacer()
                                    
                                    if viewModel.favoriteArticleIDs.contains(article.id) {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size: 12))
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
    }
    
    private var emptySearchState: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.2))
                .padding(.top, 40)
            
            Text("No results found")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
            
            Text("Try adjusting your search filters")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.4))
        }
    }
}

#Preview {
    SearchViewFM()
        .environmentObject(MainViewModelFM())
}
