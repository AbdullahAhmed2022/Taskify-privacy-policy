import Foundation

class TodoStorage: ObservableObject {
    @Published var todos: [TodoItem] = [] {
        didSet {
            save()
        }
    }

    let key = "todos"

    init() {
        load()
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decoded
        }
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
