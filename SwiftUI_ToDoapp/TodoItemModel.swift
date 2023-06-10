//
//  TodoItemModel.swift
//  SwiftUI_ToDoapp
//
//  Created by 福原雅隆 on 2023/03/19.
//

import Foundation
import SwiftUI

struct TodoItem: Identifiable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
    let dueDate: Date
    let priority: TaskPriority
}

enum TaskPriority: String, Codable, Identifiable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    var id: String {
        return self.rawValue
    }
    
    var localizedStringKey: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
}

struct Task: Identifiable, Codable {
    let id: UUID
    let title: String
    let dueDate: Date
    let priority: TaskPriority
    var isCompleted: Bool

    init(title: String, dueDate: Date, priority: TaskPriority, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
