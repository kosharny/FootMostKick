import Foundation

struct TaskFM: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let difficulty: String
    let duration: Int
    let steps: [TaskStepFM]
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, difficulty, duration, steps, imageName
    }
}

struct TaskStepFM: Identifiable, Codable {
    let id: String
    let title: String
    let instruction: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, instruction, time
    }
}
