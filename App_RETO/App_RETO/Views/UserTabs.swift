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
    @Binding var idusuario: Int
    @State private var turnos: [Turn] = []
    @State private var turnoId: Int? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoadingTurnos = false

    var body: some View {
        TabView(selection: $router.selected) {
            
            // MARK: - Dashboard
            NavigationStack(path: $router.pathDashboard) {
                DashboardUserView(
                    usuario: $usuario,
                    loggedIn: $loggedIn,
                    idusuario: $idusuario,
                    TurnoId: $turnoId,
                    turnos: $turnos
                )
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            .tag(TabID.dashboard)
            
            // MARK: - Turno
            NavigationStack(path: $router.pathTurno) {
                TurnoView(usuario: $usuario, loggedIn: $loggedIn, idusuario: $idusuario)
            }
            .tabItem { Label("Turno", systemImage: "calendar.badge.plus") }
            .tag(TabID.turno)
            
            // MARK: - Ver Turno
            NavigationStack(path: $router.pathVer) {
                VerTurnoView(
                    usuario: $usuario,
                    loggedIn: $loggedIn,
                    TurnoId: $turnoId,
                    turnos: $turnos
                )
            }
            .tabItem { Label("Ver Turno", systemImage: "list.bullet.rectangle") }
            .tag(TabID.ver)
            
            // MARK: - Más
            NavigationStack(path: $router.pathMore) {
                MoreView(usuario: $usuario, idusuario: $idusuario)
            }
            .tabItem { Label("Más", systemImage: "ellipsis.circle") }
            .tag(TabID.more)
        }
        .tint(Color.marca)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "tabGray") ?? UIColor.systemGray6
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            Task { await actualizarTurnos() }
        }
        .onChange(of: router.selected) { newTab in
            if newTab == .dashboard {
                Task { await actualizarTurnos() }
                router.necesitaActualizarTurnos = false
            }
        }
        .onChange(of: router.necesitaActualizarTurnos) { needsUpdate in
            if needsUpdate {
                Task { await actualizarTurnos() }
                router.necesitaActualizarTurnos = false
            }
        }
    }
    
    // MARK: - Función de actualización de turnos
    func actualizarTurnos() async {
        await Task.detached(priority: .high) {
            do {
                let nuevosTurnos = try await fetchUserTurns(userId: idusuario)
                await MainActor.run {
                    if nuevosTurnos != turnos {
                        turnos = nuevosTurnos
                        turnoId = nuevosTurnos.first?.IDTurno
                        print("✅ Turnos actualizados (\(nuevosTurnos.count) encontrados)")
                    } else {
                        print("ℹ️ No hubo cambios en los turnos, se mantiene el estado actual")
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "No se pudieron obtener los turnos."
                    print("⚠️ Error al actualizar turnos: \(error)")
                }
            }
        }.value
    }
}


// MARK: - Vista “Más”
struct MoreView: View {
    @Binding var usuario: String
    @Binding var idusuario: Int

    var body: some View {
        List {
            NavigationLink(destination: HoraPicoView()) {
                Label("Hora Pico", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
            }
            NavigationLink(destination: UserMap()) {
                Label("Mapa", systemImage: "map.circle.fill")
            }
            NavigationLink(destination: UserCallView(idusuario: $idusuario)) {
                Label("Llamada", systemImage: "phone")
            }
            NavigationLink(destination: AppointmentHistoryView(idusuario: $idusuario, usuario: $usuario)) {
                Label("Historial de Citas", systemImage: "document.on.clipboard")
            }
        }
        .navigationTitle("Más opciones")
    }
}
