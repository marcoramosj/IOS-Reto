//
//  ContentView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardAdminView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Panel")
                }
            
            AdminView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Admin")
                }
        }
    }
}

#Preview {
    ContentView()
}
