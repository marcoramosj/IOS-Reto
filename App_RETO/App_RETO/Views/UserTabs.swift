//
//  UserTabs.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//
import SwiftUI

struct UserTabs: View {
    @EnvironmentObject var router: Router
    @Binding var usuario: String
    @Binding var loggedIn: Bool

    var body: some View {
        TabView(selection: $router.selected) {
            NavigationStack(path: $router.pathDashboard) {
                DashboardUserView(usuario: $usuario, loggedIn: $loggedIn)
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            .tag(TabID.dashboard)

            NavigationStack(path: $router.pathTurno) {
                TurnoView(usuario: $usuario, loggedIn: $loggedIn)
            }
            .tabItem { Label("Turno", systemImage: "calendar.badge.plus") }
            .tag(TabID.turno)

            NavigationStack(path: $router.pathVer) {
                VerTurnoView(usuario: $usuario, loggedIn: $loggedIn)
            }
            .tabItem { Label("Ver Turno", systemImage: "list.bullet.rectangle") }
            .tag(TabID.ver)
        }
        .tint(Color.marca)
        .background(Color.tabGray)
        .tabBarStyleGray()
        .navBarStyleGray()
    }
}
