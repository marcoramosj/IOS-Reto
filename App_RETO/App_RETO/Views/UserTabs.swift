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
            NavigationStack { DashboardUserView(usuario: $usuario, loggedIn: $loggedIn) }
                .tabItem { Label("Dashboard", systemImage: "house.fill") }

            NavigationStack { TurnoView(usuario: $usuario, loggedIn: $loggedIn) }
                .tabItem { Label("Turno", systemImage: "calendar.badge.plus") }

            NavigationStack { VerTurnoView(usuario: $usuario, loggedIn: $loggedIn) }
                .tabItem { Label("Ver Turno", systemImage: "list.bullet.rectangle") }
        }
        .tint(Color.marca)
        .background(Color.tabGray)
        .tabBarStyleGray()
        .navBarStyleGray()
    }
}

#Preview { UserTabs(usuario: .constant("Usuario Demo"), loggedIn: .constant(true)) }
