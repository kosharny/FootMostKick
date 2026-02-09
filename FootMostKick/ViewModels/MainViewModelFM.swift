import Foundation
import SwiftUI
import Combine

@MainActor
class MainViewModelFM: ObservableObject {
    @Published var articles: [ArticleFM] = []
    @Published var tasks: [TaskFM] = []
    @Published var themes: [ThemeFM] = []
    @Published var journalEntries: [JournalEntryFM] = []
    @Published var favoriteArticleIDs: Set<String> = []
    @Published var favoriteTaskIDs: Set<String> = []
    @Published var completedTaskIDs: Set<String> = []
    @Published var selectedThemeID: String = "default"
    @Published var hasCompletedOnboarding: Bool = false
    @Published var showSplash: Bool = true
    @Published var selectedTab: Int = 0
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String = "All"
    @Published var justCompletedTask: Bool = false
    @Published var showTabBar: Bool = true
    @Published var userPosition: String? = nil
    @Published var premiumEnabled: Bool = false
    
    @ObservedObject var storeManager = StoreManagerFM.shared
    private var cancellables = Set<AnyCancellable>()
    
    var currentTheme: ColorThemeFM {
        // Resolve theme based on premium status
        let themeId = MainViewModelFM.resolveThemeID(id: selectedThemeID, purchasedIDs: storeManager.purchasedProductIDs)
        
        switch themeId {
        case "ocean":
            return .oceanTheme
        case "midnight":
            return .midnightTheme
        default:
            return .defaultTheme
        }
    }
    
    var completedTasksCount: Int {
        completedTaskIDs.count
    }
    
    var readArticlesCount: Int {
        journalEntries.filter { $0.type == .articleRead }.count
    }
    
    var activeDaysCount: Int {
        let uniqueDays = Set(journalEntries.map { Calendar.current.startOfDay(for: $0.timestamp) })
        return uniqueDays.count
    }
    
    var progressPercentage: Double {
        let totalActivities = completedTasksCount + readArticlesCount
        let totalAvailable = tasks.count + articles.count
        guard totalAvailable > 0 else { return 0 }
        return Double(totalActivities) / Double(totalAvailable)
    }
    
    init() {
        // Load favorites and completion status
        if let storedFavArticles = UserDefaults.standard.array(forKey: "favoriteArticleIDs") as? [String] {
            favoriteArticleIDs = Set(storedFavArticles)
        }
        if let storedFavTasks = UserDefaults.standard.array(forKey: "favoriteTaskIDs") as? [String] {
            favoriteTaskIDs = Set(storedFavTasks)
        }
        if let storedCompletedTasks = UserDefaults.standard.array(forKey: "completedTaskIDs") as? [String] {
            completedTaskIDs = Set(storedCompletedTasks)
        }
        
        selectedThemeID = UserDefaults.standard.string(forKey: "selectedThemeID") ?? "default"
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        userPosition = UserDefaults.standard.string(forKey: "userPosition")
        
        // Load journal entries
        if let data = UserDefaults.standard.data(forKey: "journalEntries"),
           let decoded = try? JSONDecoder().decode([JournalEntryFM].self, from: data) {
            journalEntries = decoded
        }
        
        loadData()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        storeManager.$purchasedProductIDs
            .sink { [weak self] purchasedIDs in
                guard let self = self else { return }
                self.premiumEnabled = !purchasedIDs.isEmpty
                
                // Re-validate current theme selection
                let resolved = MainViewModelFM.resolveThemeID(id: self.selectedThemeID, purchasedIDs: purchasedIDs)
                if resolved != self.selectedThemeID {
                    self.selectedThemeID = resolved
                }
            }
            .store(in: &cancellables)
    }
    
    static func resolveThemeID(id: String, purchasedIDs: Set<String>) -> String {
        // Add mapping of theme ID to product ID if needed
        let themeProductIDMap: [String: String] = [
            "ocean": "premium_theme_ocean_breeze",
            "midnight": "premium_theme_midnight_sky"
        ]
        
        guard let productID = themeProductIDMap[id] else {
            // It's a free theme or unknown
            return id
        }
        
        // If it's a premium theme, check if purchased
        if purchasedIDs.contains(productID) {
            return id
        } else {
            return "default"
        }
    }
    
    private func loadData() {
        // Load Articles
        if let url = Bundle.main.url(forResource: "articles", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedArticles = try? JSONDecoder().decode([ArticleFM].self, from: data) {
            self.articles = decodedArticles
        }
        
        // Load Tasks
        if let url = Bundle.main.url(forResource: "tasks", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedTasks = try? JSONDecoder().decode([TaskFM].self, from: data) {
            self.tasks = decodedTasks
        }
        
        // Setup Themes
        self.themes = [
            ThemeFM(id: "default", name: "Default Blue", isPremium: false, productId: nil, price: nil),
            ThemeFM(id: "ocean", name: "Ocean Breeze", isPremium: true, productId: "premium_theme_ocean_breeze", price: "$0.99"),
            ThemeFM(id: "midnight", name: "Midnight Sky", isPremium: true, productId: "premium_theme_midnight_sky", price: "$0.99")
        ]
    }
    
    private func saveUserDefaults() {
        UserDefaults.standard.set(Array(favoriteArticleIDs), forKey: "favoriteArticleIDs")
        UserDefaults.standard.set(Array(favoriteTaskIDs), forKey: "favoriteTaskIDs")
        UserDefaults.standard.set(Array(completedTaskIDs), forKey: "completedTaskIDs")
        UserDefaults.standard.set(selectedThemeID, forKey: "selectedThemeID")
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userPosition, forKey: "userPosition")
        
        // Save journal entries
        if let encoded = try? JSONEncoder().encode(journalEntries) {
            UserDefaults.standard.set(encoded, forKey: "journalEntries")
        }
    }
    
    func addJournalEntry(_ entry: JournalEntryFM) {
        journalEntries.insert(entry, at: 0)
        saveUserDefaults()
    }
    
    func toggleFavoriteArticle(_ articleId: String) {
        if favoriteArticleIDs.contains(articleId) {
            favoriteArticleIDs.remove(articleId)
        } else {
            favoriteArticleIDs.insert(articleId)
        }
        saveUserDefaults()
    }
    
    func toggleFavoriteTask(_ taskId: String) {
        if favoriteTaskIDs.contains(taskId) {
            favoriteTaskIDs.remove(taskId)
        } else {
            favoriteTaskIDs.insert(taskId)
        }
        saveUserDefaults()
    }

    func markTaskCompleted(_ taskId: String) {
        if !completedTaskIDs.contains(taskId) {
            completedTaskIDs.insert(taskId)
            
            // Find task title for journal
            let taskTitle = tasks.first(where: { $0.id == taskId })?.title ?? "Unknown Task"
            
            addJournalEntry(JournalEntryFM(
                id: UUID().uuidString,
                type: .taskCompleted,
                itemId: taskId,
                itemTitle: taskTitle,
                timestamp: Date()
            ))
            
            justCompletedTask = true
            saveUserDefaults()
        } else {
             // Already completed, but maybe user wants to finish again?
             // Just set flag to navigate home
             justCompletedTask = true
        }
    }
    
    func selectTheme(_ theme: ThemeFM) {
        if theme.isPremium {
            if !storeManager.hasAccess(to: theme) {
                return
            }
        }
        
        selectedThemeID = theme.id
        saveUserDefaults()
    }
    
    func setUserPosition(_ position: String) {
        userPosition = position
        saveUserDefaults()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveUserDefaults()
    }
    
    func filteredArticles() -> [ArticleFM] {
        var filtered = articles
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchQuery.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery) ||
                $0.content.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        return filtered
    }
    
    func filteredTasks() -> [TaskFM] {
        var filtered = tasks
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.difficulty == selectedCategory }
        }
        
        if !searchQuery.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery) ||
                $0.description.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        return filtered
    }
}
