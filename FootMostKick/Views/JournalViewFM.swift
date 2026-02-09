import SwiftUI

struct JournalViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var groupedEntries: [Date: [JournalEntryFM]] {
        Dictionary(grouping: viewModel.journalEntries) { entry in
            Calendar.current.startOfDay(for: entry.timestamp)
        }
    }
    
    var sortedDates: [Date] {
        groupedEntries.keys.sorted(by: >)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderFM(title: "Journal")
                    
                    if viewModel.journalEntries.isEmpty {
                        emptyState
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 24, pinnedViews: [.sectionHeaders]) {
                                ForEach(sortedDates, id: \.self) { date in
                                    Section(header: dateHeader(for: date)) {
                                        ForEach(groupedEntries[date]!) { entry in
                                            entryCard(for: entry)
                                        }
                                    }
                                }
                                
                                Color.clear.frame(height: 80)
                            }
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No entries yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            
            Text("Complete tasks and read articles to fill your journal")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func dateHeader(for date: Date) -> some View {
        HStack {
            Text(dateFormatted(date))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(viewModel.currentTheme.primaryColor)
                        .shadow(radius: 4)
                )
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    private func entryCard(for entry: JournalEntryFM) -> some View {
        AppCardFM {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor(for: entry.type).opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: iconName(for: entry.type))
                        .font(.system(size: 20))
                        .foregroundColor(iconColor(for: entry.type))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.itemTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(timeFormatted(entry.timestamp))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func iconName(for type: JournalEntryFM.EntryType) -> String {
        switch type {
        case .articleRead: return "doc.text.fill"
        case .taskStarted: return "play.circle.fill"
        case .taskCompleted: return "checkmark.circle.fill"
        }
    }
    
    private func iconColor(for type: JournalEntryFM.EntryType) -> Color {
        switch type {
        case .articleRead: return .blue
        case .taskStarted: return .orange
        case .taskCompleted: return .green
        }
    }
    
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
    
    private func timeFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    JournalViewFM()
        .environmentObject(MainViewModelFM())
}
