//
//  NotificationService.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    
    private init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
                // Set notification categories
                self.setupNotificationCategories()
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNotificationCategories() {
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_ACTION",
            title: "Mark as Complete",
            options: [.foreground]
        )
        
        let category = UNNotificationCategory(
            identifier: "TASK_CATEGORY",
            actions: [completeAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        center.setNotificationCategories([category])
    }
    
    func scheduleNotification(for task: Task) {
        // Remove any existing notification for this task
        center.removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        
        // Only schedule if task is not completed and deadline is in the future
        guard !task.isCompleted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Deadline"
        content.body = "\(task.title) is due in ten minutes!"
        content.sound = .default
        content.categoryIdentifier = "TASK_CATEGORY"
        content.userInfo = ["taskId": task.id.uuidString]
        
        // Get the calendar components for the deadline
        let calendar = Calendar.current
        // Get deadline 10 minutes earlier
        let notificationTime = calendar.date(byAdding: .minute, value: -10, to: task.deadline) ?? task.deadline
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
        
        // Create trigger for the notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Successfully scheduled notification for task: \(task.title)")
            }
        }
    }
    
    func removeNotification(for taskId: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: [taskId.uuidString])
    }
    
    func updateNotifications(for tasks: [Task]) {
        // Remove all existing notifications
        center.removeAllPendingNotificationRequests()
        
        // Schedule new notifications for incomplete tasks
        for task in tasks where !task.isCompleted {
            scheduleNotification(for: task)
        }
    }
    
    func printPendingNotifications() {
        center.getPendingNotificationRequests { requests in
            print("Pending notifications: \(requests.count)")
            for request in requests {
                print("Notification for: \(request.content.title)")
                print("Scheduled for: \(request.trigger?.description ?? "unknown")")
            }
        }
    }
} 
