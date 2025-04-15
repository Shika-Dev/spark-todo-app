//
//  spark_todo_listApp.swift
//  spark-todo-list
//
//  Created by Parama Artha on 02/04/25.
//

import SwiftUI
import UserNotifications

@main
struct spark_todo_listApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "COMPLETE_ACTION" {
            if let taskId = response.notification.request.content.userInfo["taskId"] as? String,
               let uuid = UUID(uuidString: taskId) {
                let viewModel = DashboardViewModel()
                viewModel.updateTask(withId: uuid, isCompleted: true)
            }
        }
        completionHandler()
    }
}
