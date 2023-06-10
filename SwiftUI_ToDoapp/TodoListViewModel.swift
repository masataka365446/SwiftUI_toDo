//
//  TodoListViewModel.swift
//  SwiftUI_ToDoapp
//
//  Created by 福原雅隆 on 2023/03/19.
//

import Foundation
import SwiftUI
import Combine

class TodoListViewModel: ObservableObject {
    @Published private(set) var items: [Task] = []
    @Published var showingAddItem = false

    private let storageKey = "todoItems"

    init() {
        loadItems()
    }

    func addItem(title: String, dueDate: Date, priority: TaskPriority, shouldNotify: Bool) {
        let newItem = Task(title: title, dueDate: dueDate, priority: priority)

        if shouldNotify {
            NotificationManager.shared.scheduleNotification(for: newItem)
        }

        items.append(newItem)
        saveItems()
    }

    func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = items[index]
            NotificationManager.shared.cancelNotification(for: item)
        }

        items.remove(atOffsets: offsets)
        saveItems()
    }

    func toggleCompletion(for item: Task) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
            saveItems()
        }
    }

    private func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let items = try? JSONDecoder().decode([Task].self, from: data) {
            self.items = items
        }
    }
}
