//
//  Roottabs.swift
//  
//
//  Created by 박진혁 on 8/28/25.
//

import SwiftUI

struct RootTabs: View {
    @State private var showComposer = false

    var body: some View {
        ZStack {
            TabView {
                ContentView()
                    .tabItem { Label("Home", systemImage: "house.circle") }

                RecordsView()
                    .tabItem { Label("Records", systemImage: "doc.text") }

                NotificationsView()
                    .tabItem { Label("Alerts", systemImage: "bell") }
            }
            .tint(.orange)                                     // professor’s style
            .onAppear {
                UITabBar.appearance().backgroundColor = .white // from slides
            }                                                  //  [oai_citation:1‡Clase7_M3_TabView.pdf](file-service://file-FTfywrCQz1xVBqKK74VLxp)

            // Center “+” action (floating)
            VStack { Spacer()
                Button {
                    showComposer = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(Color(.systemTeal)))
                        .shadow(radius: 10, y: 4)
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 14)
                .sheet(isPresented: $showComposer) { AddItemSheet() }
            }
        }
    }
}
