import Foundation

enum Priority: String, CaseIterable, Codable, Identifiable {
    case low, medium, high
    var id: String { rawValue.capitalized }
}

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    var dueDate: Date
    var priority: Priority

    init(id: UUID = UUID(), title: String, isDone: Bool = false, dueDate: Date = Date(), priority: Priority = .medium) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.dueDate = dueDate
        self.priority = priority
    }
}
