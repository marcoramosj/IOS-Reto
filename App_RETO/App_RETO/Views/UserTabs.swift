//
//  UserTabs.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct UserTabs: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    
    var body: some View {
        VStack{
            TabView {
                NavigationStack {
                    DashboardUserView(usuario:$usuario , loggedIn: $loggedIn)
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
                
                NavigationStack {
                    VerTurnoView(usuario:$usuario , loggedIn: $loggedIn)
                }
                .tabItem {
                    Image(systemName: "number.circle.fill")
                    Text("Turno")
                }
                
                
            }
            .onAppear() {
                UITabBar.appearance().barTintColor = UIColor.orange
                UITabBar.appearance().backgroundColor = UIColor.white
                UITabBar.appearance().unselectedItemTintColor = UIColor.orange
            }
        }
    }
}

#Preview {
    UserTabs(usuario:.constant("") , loggedIn: .constant(true))
}
