import Foundation

struct JournalEntryFM: Identifiable, Codable {
    let id: String
    let type: EntryType
    let itemId: String
    let itemTitle: String
    let timestamp: Date
    
    enum EntryType: String, Codable {
        case articleRead
        case taskStarted
        case taskCompleted
    }
}
