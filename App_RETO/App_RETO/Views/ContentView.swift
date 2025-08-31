//
//  ContentView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usuario = ""
    @State private var loggedIn = false

    var body: some View {
        Group {
            if loggedIn {
                NavigationStack {
                    TabView {
                        DashboardAdminView(usuario: usuario)
                            .tabItem { Label("Inicio", systemImage: "house.fill") }

                        AgendarTurnoView()
                            .tabItem { Label("Agendar", systemImage: "calendar.badge.plus") }

                        VerTurnoView()
                            .tabItem { Label("Mis turnos", systemImage: "list.bullet.rectangle") }

                        AdminView()
                            .tabItem { Label("Perfil", systemImage: "person.crop.circle") }
                    }
                }
            } else {
                InicioSesion(usuario: $usuario, loggedIn: $loggedIn)
            }
        }
    }
}
