//
//  TaskModel.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import Foundation

enum TaskCategory: String, CaseIterable, Codable {
    case work = "Work"
    case study = "Study"
    case shopping = "Shopping"
    case health = "Health"
    
    var iconName: String {
        switch self {
        case .work: return "macbook"
        case .study: return "book"
        case .shopping: return "cart"
        case .health: return "stethoscope"
        }
    }
    
    var iconColor: String {
        switch self {
        case .work: return "1D92FF"
        case .study: return "BA99FF"
        case .shopping: return "6AFBA4"
        case .health: return "FF6767"
        }
    }
}

struct Task: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let deadline: Date
    var isCompleted: Bool
    var category: TaskCategory
}
