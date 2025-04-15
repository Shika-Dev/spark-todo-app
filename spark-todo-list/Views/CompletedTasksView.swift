//
//  CompletedTasksView.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import SwiftUI

struct CompletedTasksView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DashboardViewModel()
    
    private var completedTasks: [Binding<Task>] {
        $viewModel.tasks.filter { task in
            task.wrappedValue.isCompleted
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
                        Text("Completed Tasks")
                            .font(.title2)
                            .foregroundStyle(Color(hex: "#8AC0FF"))
                            .offset(x:-14)
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            if !completedTasks.isEmpty {
                                ForEach(completedTasks) { task in
                                    CompletedTaskCard(task: task, viewModel: viewModel)
                                }
                            } else {
                                Text("No Completed Tasks")
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

struct CompletedTaskCard: View {
    @Binding var task: Task
    let viewModel: DashboardViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color(hex: "#1D92FF"))
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
            Image(systemName: task.category.iconName)
                .font(.system(size: 16))
                .foregroundStyle(Color(hex: "#\(task.category.iconColor)"))
            Text(task.category.rawValue)
                .font(.system(size: 16))
        }
        .padding()
        .background(Color(hex: "#FFFFFF"))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    CompletedTasksView()
} 
