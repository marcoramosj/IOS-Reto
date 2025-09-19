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
        TabView {
            DashboardUserView(usuario: $usuario, loggedIn: $loggedIn)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            TurnoView(usuario: $usuario, loggedIn: $loggedIn)
                .tabItem {
                    Label("Turno", systemImage: "calendar.badge.plus")
                }
            
            VerTurnoView(usuario: $usuario, loggedIn: $loggedIn)
                .tabItem {
                    Label("Ver Turno", systemImage: "list.bullet.rectangle")
                }
            

        }
        .tint(Color.ColorBoton) // tus colores de marca
    }
}


#Preview {
    UserTabs(usuario: .constant("Usuario Demo"), loggedIn: .constant(true))
}
