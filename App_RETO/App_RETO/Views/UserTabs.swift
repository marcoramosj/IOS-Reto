//
//  UserTabs.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct UserTabs: View {
    let usuario: String
    @Binding var loggedIn: Bool

    var body: some View {
        TabView {
            NavigationStack {
                DashboardUserView(usuario: usuario, loggedIn: $loggedIn)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Inicio")
            }

            NavigationStack {
                TurnoView()
            }
            .tabItem {
                Image(systemName: "number.circle.fill")
                Text("Turno")
            }

            NavigationStack {
                ConfiguracionView(loggedIn: $loggedIn)
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Config.")
            }
        }
    }
}

#Preview {
    UserTabs(usuario: "marcoramos", loggedIn: .constant(true))
}
