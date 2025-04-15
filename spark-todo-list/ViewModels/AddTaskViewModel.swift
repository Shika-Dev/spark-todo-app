//
//  AddTaskViewModel.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    private var fileManagerService = FileManagerService()
    private var notificationService = NotificationService.shared
    @Published var tasks: [Task] = []
    @Published var title: String = "" {
        didSet {
            validateForm()
        }
    }
    @Published var description: String = ""
    @Published var deadline: Date = Date.now
    @Published var isCompleted: Bool = false
    @Published var isSaveDisabled: Bool = true
    @Published var category: TaskCategory = .work
    
    private let fileName = "tasks.json"
    
    init() {
        loadTasks()
    }
    
    
    private func validateForm() {
        isSaveDisabled = title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // Save Task Function
    func saveTask() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newTask = Task(title: title, description: description, deadline: deadline, isCompleted: false, category: category)
        tasks.append(newTask)
        fileManagerService.saveToFile(tasks: tasks)
        
        // Schedule notification for the new task
        notificationService.scheduleNotification(for: newTask)
        
        // Reset Fields
        title = ""
        description = ""
        deadline = Date.now
        category = .work
    }

    // Load Tasks from File
    func loadTasks() {
        if let loadedTasks = fileManagerService.loadFromFile() {
            tasks = loadedTasks
            // Update notifications for all tasks
            notificationService.updateNotifications(for: tasks)
        }
    }
}
