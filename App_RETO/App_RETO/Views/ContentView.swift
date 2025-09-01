//
//  ContentView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var usuario = ""
    @State private var loggedIn = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Group {
                if loggedIn {
                    NavigationStack {
                        TabView(selection: $appState.selectedTab) {
                            DashboardAdminView(usuario: usuario)
                                .tabItem { Label("Inicio", systemImage: "house.fill") }
                                .tag(0)

                            AgendarTurnoView(paciente: usuario)
                                .tabItem { Label("Agendar", systemImage: "calendar.badge.plus") }
                                .tag(1)

                            VerTurnoView()
                                .tabItem { Label("Mis turnos", systemImage: "list.bullet.rectangle") }
                                .tag(2)

                            AdminView()
                                .tabItem { Label("Perfil", systemImage: "person.crop.circle") }
                                .tag(3)
                        }
                        .tint(.appPrimary)
                    }
                } else {
                    InicioSesion(usuario: $usuario, loggedIn: $loggedIn)
                }
            }
        }
    }
}
