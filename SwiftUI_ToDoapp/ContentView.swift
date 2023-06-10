//
//  ContentView.swift
//  SwiftUI_ToDoapp
//
//  Created by 福原雅隆 on 2023/03/19.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var newTaskTitle = ""
    @State private var newTaskDueDate = Date()
    @State private var newTaskPriority = TaskPriority.medium
    @State private var newTaskShouldNotify = false
    
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.items) { item in
                        Button(action: {
                            viewModel.toggleCompletion(for: item)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(LocalizedStringKey(item.title))
                                        .font(.headline)
                                        .strikethrough(item.isCompleted)
                                    
                                    HStack(spacing: 8) {
                                        Text(LocalizedStringKey(String(format: NSLocalizedString("PriorityTitle", comment: ""), NSLocalizedString(item.priority.rawValue, comment: ""))))
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                                                            
                                        Text(LocalizedStringKey("|"))
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                                                            
                                        let dueDateString = dateFormatter.string(from: item.dueDate)
                                        Text(LocalizedStringKey(String(format: NSLocalizedString("Due", comment: ""), dueDateString)))
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                ZStack {
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                    if item.isCompleted {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                            .padding(.vertical, 0)
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
                .listStyle(PlainListStyle())
                .onAppear(perform: NotificationManager.shared.requestPermission)
//                .navigationTitle(LocalizedStringKey("ToDo List"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.showingAddItem.toggle()
                        }) {
                            Image("plus_icon2")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .padding()
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                }
                .sheet(isPresented: $viewModel.showingAddItem) {
                    NavigationView {
                        Form {
                            TextField(LocalizedStringKey("Task Title"), text: $newTaskTitle)
                                .focused($isTextFieldFocused)
                            DatePicker(LocalizedStringKey("Due Date"), selection: $newTaskDueDate, displayedComponents: [.date, .hourAndMinute])
                            Picker(LocalizedStringKey("Priority"), selection: $newTaskPriority) {
                                ForEach(TaskPriority.allCases) { priority in
                                    Text(LocalizedStringKey(priority.rawValue)).tag(priority)
                                }
                            }
                            Toggle(LocalizedStringKey("Send Notification"), isOn: $newTaskShouldNotify)
                        }
                        .navigationBarTitle(LocalizedStringKey("New Task"), displayMode: .inline)
                        .navigationBarItems(leading: Button(LocalizedStringKey("Cancel")) {
                            viewModel.showingAddItem = false
                            newTaskTitle = ""
                        }, trailing: Button(LocalizedStringKey("Add")) {
                            viewModel.addItem(title: newTaskTitle, dueDate: newTaskDueDate, priority: newTaskPriority, shouldNotify: newTaskShouldNotify)
                            viewModel.showingAddItem = false
                            newTaskTitle = ""
                        }
                            .disabled(newTaskTitle.isEmpty)
                        )
                        .onAppear {
                            isTextFieldFocused = true
                        }
                    }
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
