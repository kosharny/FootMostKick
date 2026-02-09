import Foundation

struct ArticleFM: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let category: String
    let readTime: Int
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, category, readTime, imageName
    }
}
