import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties
    
    private let repository: ToDoListRepositoryType
    
    // MARK: - Outputs
    
    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
            applyFilter(at: filterIndex) 
        }
    }
    
    @Published var filteredToDoItems: [ToDoItem] = [] // save the filteredItems into a new array
    @Published var filterIndex = 0 // create an index equal to 0 for filtering with picker
    
    // MARK: - Init
    
    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
    }
    
    // MARK: - Inputs
    
    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
        
    }
    
    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()
            applyFilter(at: filterIndex) // after each modification func is called to update data
        }
    }
    
    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
        applyFilter(at: filterIndex) // after each modification func is called to update data
    }
    
    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        filterIndex = index
        switch index {
        case 0:
            filteredToDoItems = toDoItems // all items a displayed
        case 1:
            filteredToDoItems = toDoItems.filter { $0.isDone } // keep items with done true from [TodoItem] and apply it to the filtered array
        case 2:
            filteredToDoItems = toDoItems.filter { !$0.isDone }// keep items with !done true from [TodoItem] and apply it to the filtered array
        default :
            filteredToDoItems = toDoItems
        }
    }
}
