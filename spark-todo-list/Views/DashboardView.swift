//
//  DashboardView.swift
//  spark-todo-list
//
//  Created by Parama Artha on 02/04/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var isPresented = false
    @State private var isShowingCompletedTasks = false
    @State private var isCategorySheetPresented = false
    
    private var incompleteTasks: [Binding<Task>] {
            $viewModel.tasks.filter { task in
                !task.wrappedValue.isCompleted &&
                Calendar.current.isDateInToday(task.wrappedValue.deadline)
            }
        }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECF0FB")
                    .ignoresSafeArea()
                VStack{
                    HStack {
                        Image(systemName: "house")
                            .font(.system(size: 24))
                            .foregroundStyle(Color(hex: "#67ADFF"))
                        Spacer()
                        Image(systemName: "person")
                            .font(.system(size: 24))
                            .foregroundStyle(Color(hex: "#67ADFF"))
                    }
                    .padding(.horizontal)
                    HStack{
                        Text("Manage your\ntime well")
                            .font(.title2)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.leading)
                        Image("Arrow")
                        Image(systemName: "book.pages")
                            .font(.system(size: 50))
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 140)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#99C3FC"), Color(hex: "#6498E1")]), startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .clipShape(.rect(cornerRadius: 23))
                    .shadow(color: Color(hex: "#67ADFF").opacity(0.34), radius: 10, x: -2, y: 10)
                    .padding()
                    Spacer()
                    Text("Categories")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    HStack{
                        CategoryButton(iconName: "macbook", categoryName: "Work", iconColor: "1D92FF", isSheetPresented: $isCategorySheetPresented)
                        Spacer()
                        CategoryButton(iconName: "book", categoryName: "Study", iconColor: "BA99FF", isSheetPresented: $isCategorySheetPresented)
                        Spacer()
                        CategoryButton(iconName: "cart", categoryName: "Shoping", iconColor: "6AFBA4", isSheetPresented: $isCategorySheetPresented)
                        Spacer()
                        CategoryButton(iconName: "stethoscope", categoryName: "Health", iconColor: "FF6767", isSheetPresented: $isCategorySheetPresented)
                    }
                    .padding()
                    Spacer()
                    HStack{
                        Text("You have \(incompleteTasks.count) tasks for today")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                        Spacer()
                        Text("Completed Task")
                            .font(.system(size: 14, weight: .regular))
                            .onTapGesture {
                                isShowingCompletedTasks = true
                            }
                            .sheet(isPresented: $isShowingCompletedTasks) {
                                CompletedTasksView()
                            }
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .padding(.trailing, 16)
                    }
                    ScrollView{
                        VStack(spacing: 12){
                            if !incompleteTasks.isEmpty {
                                ForEach(incompleteTasks){task in
                                    TaskCard(task: task, viewModel: viewModel)
                                }
                            } else {
                                Text("No Task For Today")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                        }
                    }
                    .padding()
                    .background(Color(hex: "#D9D9D9"))
                    .clipShape(.rect(cornerRadius: 17))
                    .padding()
                }
                VStack{
                    Spacer()
                    BottomNavigationBar(isPresented: $isPresented)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationDestination(isPresented: $isPresented){ AddTaskView()
            }
        }
        .onChange(of: isPresented) { oldValue, newValue in
            if !newValue {
                viewModel.loadTasks()
            }
        }
        .onChange(of: isCategorySheetPresented) { oldValue, newValue in
            if !newValue {
                viewModel.loadTasks()
            }
        }
    }
}

#Preview {
    DashboardView()
}

struct CategoryButton: View {
    let iconName: String
    let categoryName: String
    let iconColor: String
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .padding()
                .font(.system(size: 24))
                .foregroundStyle(Color(hex: iconColor))
                .frame(width: 51, height: 51)
                .background(Color(hex: "#FCFFFC"))
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: Color(hex: "#8F67FF").opacity(0.5), radius: 5, x: 0, y: 0)
                .onTapGesture {
                    isSheetPresented = true
                }
            Text(categoryName)
                .font(.system(size: 16))
                .foregroundStyle(Color(hex: "#000000").opacity(0.5))
                .padding(.top, 5)
        }
        .sheet(isPresented: $isSheetPresented) {
            if let category = TaskCategory(rawValue: categoryName) {
                CategoryTasksView(category: category)
            }
        }
    }
}

struct TaskCard: View {
    @Binding var task: Task
    let viewModel: DashboardViewModel
    
    var body: some View {
        HStack{
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "exclamationmark.circle")
                .foregroundStyle(Color(hex: task.isCompleted ? "#1D92FF" : "#FF6767"))
            Text(task.title)
                .font(.system(size: 16))
                .foregroundStyle(Color(hex: "#000000"))
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#FFFFFF"))
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture {
            viewModel.updateTask(withId: task.id, isCompleted: true)
            viewModel.loadTasks()
        }
    }
}

struct BottomNavigationBar: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack{
            Circle()
                .fill(LinearGradient(colors: [
                    Color(hex: "#A3C6FC"), Color(hex: "#9747FF")
                ], startPoint: .top, endPoint: .bottom))
                .frame(height:UIScreen.main.bounds.width * 0.7)
                .shadow(color: .black.opacity(0.25), radius: 11, x: 1, y: -8)
                .offset(y:UIScreen.main.bounds.width * 0.45)
            HStack{
                ZStack {
                    Circle()
                        .fill(Color(hex: "#525252"))
                        .frame(width: 45, height: 45)
                        .shadow(radius: 5)

                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#67ADFF"))
                }
                .offset(y: UIScreen.main.bounds.width * 0.1)
                .onTapGesture {
                    isPresented = true
                }
            }
            Image("SparkPlus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.3)
                .offset(y: UIScreen.main.bounds.width * 0.25)
        }
    }
}
