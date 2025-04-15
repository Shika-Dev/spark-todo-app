//
//  DashboardViewModel.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import Foundation

class DashboardViewModel: ObservableObject {
    private var fileManagerService = FileManagerService()
    private var notificationService = NotificationService.shared
    @Published var tasks: [Task] = []
    
    private let fileName = "tasks.json"
    
    init() {
        loadTasks()
    }

    // Load Tasks from File
    func loadTasks() {
        if let loadedTasks = fileManagerService.loadFromFile() {
            tasks = loadedTasks
            // Update notifications for all tasks
            notificationService.updateNotifications(for: tasks)
        }
    }
    
    // Update Task Function
    func updateTask(withId id: UUID, isCompleted: Bool) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index].isCompleted = isCompleted
            fileManagerService.saveToFile(tasks: tasks)
            
            // Update notification for this task
            if isCompleted {
                notificationService.removeNotification(for: id)
            } else {
                notificationService.scheduleNotification(for: tasks[index])
            }
        }
    }
    
    // Format Date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
