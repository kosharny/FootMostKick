import SwiftUI

struct DetailsViewFM: View {
    let task: TaskFM?
    let article: ArticleFM?
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    @State private var showTaskFlow = false
    
    // Initializer for Task
    init(task: TaskFM) {
        self.task = task
        self.article = nil
    }
    
    // Initializer for Article
    init(article: ArticleFM) {
        self.task = nil
        self.article = article
    }
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        heroImage
                        
                        titleSection
                        
                        statsRow
                        
                        if let task = task {
                            taskContent(task)
                        } else if let article = article {
                            articleContent(article)
                        }
                        
                        Color.clear.frame(height: 100)
                    }
                }
            }
            
            // Bottom Action Button for Tasks
            if task != nil {
                VStack {
                    Spacer()
                    startButton
                }
            }
        }
        .fullScreenCover(isPresented: $showTaskFlow) {
            if let task = task {
                TaskFlowViewFM(task: task)
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            if viewModel.justCompletedTask {
                presentationMode.wrappedValue.dismiss()
                viewModel.justCompletedTask = false
                return
            }
            viewModel.showTabBar = false
            if let article = article {
                viewModel.addJournalEntry(JournalEntryFM(
                    id: UUID().uuidString,
                    type: .articleRead,
                    itemId: article.id,
                    itemTitle: article.title,
                    timestamp: Date()
                ))
            }
        }
        .onDisappear {
            viewModel.showTabBar = true
        }
        .onChange(of: viewModel.justCompletedTask) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
                viewModel.justCompletedTask = false
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.1)))
            }
            
            Spacer()
            
            Button(action: {
                if let task = task {
                    viewModel.toggleFavoriteTask(task.id)
                } else if let article = article {
                    viewModel.toggleFavoriteArticle(article.id)
                }
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isFavorite ? .red : .white)
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.1)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(viewModel.currentTheme.primaryColor.opacity(0.8).ignoresSafeArea(edges: .top))
    }
    
    private var isFavorite: Bool {
        if let task = task {
            return viewModel.favoriteTaskIDs.contains(task.id)
        } else if let article = article {
            return viewModel.favoriteArticleIDs.contains(article.id)
        }
        return false
    }
    
    private var heroImage: some View {
        Group {
            if let imageName = task?.imageName ?? article?.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .clipped()
            } else {
                Image(systemName: task != nil ? "figure.soccer" : "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(viewModel.currentTheme.accentColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.white.opacity(0.05))
            }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task?.title ?? article?.title ?? "")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                if let task = task, viewModel.completedTaskIDs.contains(task.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 24))
                }
            }
            .padding(.horizontal, 20)
            
            if let category = article?.category {
                Text(category.uppercased())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(viewModel.currentTheme.accentColor)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    private var statsRow: some View {
        HStack(spacing: 20) {
            if let task = task {
                statItem(icon: "clock", text: "\(task.duration) min")
                statItem(icon: "chart.bar", text: task.difficulty)
                statItem(icon: "list.number", text: "\(task.steps.count) steps")
            } else if let article = article {
                statItem(icon: "clock", text: "\(article.readTime) min read")
                statItem(icon: "tag.fill", text: article.category)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func statItem(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(viewModel.currentTheme.accentColor)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
    
    private func taskContent(_ task: TaskFM) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(task.description)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 20)
            
            Text("Steps Preview")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ForEach(Array(task.steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 16) {
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(viewModel.currentTheme.primaryColor)
                        .frame(width: 30, height: 30)
                        .background(
                            Circle().fill(viewModel.currentTheme.accentColor)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(step.instruction)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func articleContent(_ article: ArticleFM) -> some View {
        let paragraphs = article.content
            .replacingOccurrences(of: "\\n", with: "\n")
            .components(separatedBy: "\n\n")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        return VStack(alignment: .leading, spacing: 16) {
            ForEach(paragraphs, id: \.self) { paragraph in
                Text(paragraph)
                    .font(.system(size: 16))
                    .lineSpacing(6)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(viewModel.currentTheme.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(viewModel.currentTheme.accentColor.opacity(0.2), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Mark as Read")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(viewModel.currentTheme.accentColor)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private var startButton: some View {
        Button(action: {
            showTaskFlow = true
        }) {
            Text("Start Training")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(viewModel.currentTheme.primaryColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.currentTheme.accentColor)
                .cornerRadius(16)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [viewModel.currentTheme.primaryColor.opacity(0), viewModel.currentTheme.primaryColor],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
