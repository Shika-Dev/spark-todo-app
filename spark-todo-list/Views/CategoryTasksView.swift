//
//  CategoryTasksView.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import SwiftUI

struct CategoryTasksView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DashboardViewModel()
    let category: TaskCategory
    
    private var tasks: [Binding<Task>] {
        $viewModel.tasks.filter { task in
            task.wrappedValue.category == category
        }.sorted { task1, task2 in
            if task1.wrappedValue.isCompleted == task2.wrappedValue.isCompleted {
                return task1.wrappedValue.deadline < task2.wrappedValue.deadline
            }
            return !task1.wrappedValue.isCompleted && task2.wrappedValue.isCompleted
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECF0FB")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.title2)
                                .foregroundStyle(Color(hex: "#8AC0FF"))
                        }
                        Spacer()
                        HStack {
                            Image(systemName: category.iconName)
                                .foregroundStyle(Color(hex: category.iconColor))
                            Text(category.rawValue)
                                .font(.title2)
                                .foregroundStyle(Color(hex: "#8AC0FF"))
                        }
                        .offset(x: -14)
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            if !tasks.isEmpty {
                                ForEach(tasks) { task in
                                    CategoryTaskCard(task: task, viewModel: viewModel)
                                }
                            } else {
                                Text("No Tasks in \(category.rawValue)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#000000").opacity(0.5))
                                    .padding()
                            }
                        }
                        .padding()
                    }
                    .background(Color(hex: "#D9D9D9"))
                    .clipShape(.rect(cornerRadius: 17))
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }
}

struct CategoryTaskCard: View {
    @Binding var task: Task
    let viewModel: DashboardViewModel
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "exclamationmark.circle")
                .foregroundStyle(Color(hex: task.isCompleted ? "#1D92FF" : "#FF6767"))
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "#000000"))
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#000000").opacity(0.5))
                }
                Text(viewModel.formattedDate(task.deadline))
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "#000000").opacity(0.5))
            }
            Spacer()
        }
        .padding()
        .background(Color(hex: "#FFFFFF"))
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture {
            viewModel.updateTask(withId: task.id, isCompleted: !task.isCompleted)
            viewModel.loadTasks()
        }
    }
}

#Preview {
    CategoryTasksView(category: .work)
} 
