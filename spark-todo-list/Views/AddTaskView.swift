//
//  AddTaskView.swift
//  spark-todo-list
//
//  Created by Parama Artha on 04/04/25.
//

import SwiftUI

struct AddTaskView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [
                        Color(hex: "#FFFFFF"), Color(hex: "#67ADFF")
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(height:UIScreen.main.bounds.width * 1)
                    .shadow(color: .black.opacity(0.25), radius: 11, x: 1, y: -8)
                    .offset(y:-UIScreen.main.bounds.height * 0.5)
                Image("SparkPlus")
                    .offset(y: -UIScreen.main.bounds.height * 0.4)
            }
            VStack {
                Spacer()
                    .frame(height:UIScreen.main.bounds.width * 0.5)
                HStack {
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundStyle(Color(hex: "#8AC0FF"))
                            
                    }
                    Spacer()
                    Text("Add Task")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "#8AC0FF"))
                        .offset(x: -14)
                    Spacer()
                }
                .padding()
                ScrollView{
                    CustomTextField(text: $viewModel.title, hint: "Title (required)")
                    CustomTextField(text: $viewModel.description, hint: "Description")
                    CustomDatePicker(date: $viewModel.deadline, hint: "When is it due?")
                    CategoryDropdown(viewModel: viewModel)
                    
                    Button(action: {
                        viewModel.saveTask()
                    }){
                        Text("Add Task")
                            .padding()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#1882FF"))
                            .clipShape(Capsule())
                            .padding()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddTaskView()
}

struct CustomTextField : View {
    @Binding var text: String
    let hint: String
    var body: some View {
        TextField(hint, text: $text)
            .foregroundStyle(Color(hex: "#000000"))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color(hex: "#494949").opacity(0.38), lineWidth: 2)
                    .background(.white)
            )
            .padding()
    }
}

struct CustomDatePicker : View {
    @Binding var date: Date
    let hint: String
    var body: some View {
        DatePicker(hint, selection: $date, displayedComponents: .date)
            .foregroundStyle(Color(hex: "#000000"))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color(hex: "#494949").opacity(0.38), lineWidth: 2)
                    .background(.white)
            )
            .padding()
    }
}


struct CategoryDropdown: View {
    @State private var isCategoryDropdownVisible = false
    let viewModel : AddTaskViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                isCategoryDropdownVisible.toggle()
            }) {
                HStack {
                    Image(systemName: viewModel.category.iconName)
                        .foregroundStyle(Color(hex: viewModel.category.iconColor))
                    Text(viewModel.category.rawValue)
                        .foregroundStyle(Color(hex: "#000000"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color(hex: "#000000"))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color(hex: "#494949").opacity(0.38), lineWidth: 2)
                        .background(.white)
                )
            }
            
            if isCategoryDropdownVisible {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Button(action: {
                            viewModel.category = category
                            isCategoryDropdownVisible = false
                        }) {
                            HStack {
                                Image(systemName: category.iconName)
                                    .foregroundStyle(Color(hex: category.iconColor))
                                Text(category.rawValue)
                                    .foregroundStyle(Color(hex: "#000000"))
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 2)
            }
        }
        .padding()
    }
}
