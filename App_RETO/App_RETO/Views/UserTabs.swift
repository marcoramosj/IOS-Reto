//
//  UserTabs.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//
// UserTabs.swift
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
            
            NavigationStack(path: $router.pathHora) {
                HoraPicoView()
            }
            .tabItem { Label("Hora Pico", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90") }
            .tag(TabID.hora)
        }
        
    }
}


struct UserTabs_Previews: PreviewProvider {
    @State static var testUsuario = "UsuarioPrueba"
    @State static var testLoggedIn = true
    @StateObject static var testRouter = Router()

    static var previews: some View {
        UserTabs(
            usuario: $testUsuario,
            loggedIn: $testLoggedIn
        )
        .environmentObject(testRouter)
    }
}
