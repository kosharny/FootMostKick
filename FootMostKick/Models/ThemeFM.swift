import Foundation

struct ThemeFM: Identifiable, Codable {
    let id: String
    let name: String
    let isPremium: Bool
    let productId: String?
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, isPremium, productId, price
    }
}
