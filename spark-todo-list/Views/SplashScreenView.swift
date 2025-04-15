//
//  SplashScreenView.swift
//  spark-todo-list
//
//  Created by Parama Artha on 15/04/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            DashboardView()
        } else {
            ZStack {
                Image("SparkPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .background(LinearGradient(
                colors: [.white, Color(hex: "#67ADFF")], startPoint: .top, endPoint: .bottom
            ))
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

