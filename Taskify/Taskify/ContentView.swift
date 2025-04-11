import SwiftUI

struct ContentView: View {
    @StateObject private var storage = TodoStorage()
    @State private var newTitle = ""
    @State private var dueDate = Date()
    @State private var selectedPriority: Priority = .medium
    @State private var filterPriority: Priority?

    @State private var editingTodo: TodoItem?
    @State private var editedTitle: String = ""

    var filteredTodos: [TodoItem] {
        if let filter = filterPriority {
            return storage.todos.filter { $0.priority == filter }
        }
        return storage.todos
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Text("New Task")
                    .font(.title2).bold()

                TextField("Task title", text: $newTitle)
                    .onSubmit {
                        addTask()
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Picker("Priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.rawValue.capitalized).tag(priority)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Button(action: addTask) {
                    Label("Add Task", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                Divider()

                HStack {
                    Text("Tasks")
                        .font(.title2).bold()
                    Spacer()
                    Picker("Filter", selection: $filterPriority) {
                        Text("All").tag(Priority?.none)
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue.capitalized).tag(Priority?.some(priority))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                List {
                    ForEach(filteredTodos) { todo in
                        HStack {
                            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.isDone ? .green : .gray)
                                .onTapGesture {
                                    toggleDone(todo)
                                }

                            VStack(alignment: .leading) {
                                Text(todo.title)
                                    .strikethrough(todo.isDone)
                                    .font(.headline)
                                Text("Due: \(todo.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                            Text(todo.priority.rawValue.capitalized)
                                .font(.caption2)
                                .padding(6)
                                .background(priorityColor(todo.priority))
                                .cornerRadius(6)
                                .foregroundColor(.white)

                            // Edit button
                            Button(action: {
                                startEditing(todo)
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing)

                            // Delete button
                            Button(action: {
                                deleteTask(todo)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: delete)
                }

                Spacer()
            }
            .padding()
            .frame(minWidth: 500)
        }
        .sheet(item: $editingTodo) { todo in
            VStack {
                Text("Edit Task")
                    .font(.title2).bold()
                TextField("Edit task title", text: $editedTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    saveEditedTask(todo)
                }) {
                    Text("Save Changes")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
        }
    }

    func addTask() {
        guard !newTitle.isEmpty else { return }
        let new = TodoItem(title: newTitle, dueDate: dueDate, priority: selectedPriority)
        storage.todos.append(new)
        newTitle = ""
        dueDate = Date()
        selectedPriority = .medium
    }

    func toggleDone(_ todo: TodoItem) {
        if let index = storage.todos.firstIndex(where: { $0.id == todo.id }) {
            storage.todos[index].isDone.toggle()
        }
    }

    func deleteTask(_ todo: TodoItem) {
        if let index = storage.todos.firstIndex(where: { $0.id == todo.id }) {
            storage.todos.remove(at: index)
        }
    }

    func delete(at offsets: IndexSet) {
        storage.todos.remove(atOffsets: offsets)
    }

    func startEditing(_ todo: TodoItem) {
        editingTodo = todo
        editedTitle = todo.title
    }

    func saveEditedTask(_ todo: TodoItem) {
        if let index = storage.todos.firstIndex(where: { $0.id == todo.id }) {
            storage.todos[index].title = editedTitle
        }
        editingTodo = nil
    }

    func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}

#Preview {
    ContentView()
}
