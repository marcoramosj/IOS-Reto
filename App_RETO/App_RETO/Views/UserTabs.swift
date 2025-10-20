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
    @Binding var idusuario: Int
    @State private var turnos: [Turn] = []
    @State private var turnoId: Int? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoadingTurnos = false
    
    
    var body: some View {
        TabView(selection: $router.selected) {
            NavigationStack(path: $router.pathDashboard) {
                DashboardUserView(usuario: $usuario, loggedIn: $loggedIn, idusuario: $idusuario, TurnoId: $turnoId, turnos: $turnos)
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            .tag(TabID.dashboard)
            
            NavigationStack(path: $router.pathTurno) {
                TurnoView(usuario: $usuario, loggedIn: $loggedIn, idusuario: $idusuario)
            }
            .tabItem { Label("Turno", systemImage: "calendar.badge.plus") }
            .tag(TabID.turno)
            
            NavigationStack(path: $router.pathVer) {
                VerTurnoView(usuario: $usuario, loggedIn: $loggedIn, TurnoId: $turnoId, turnos: $turnos)
            }
            .tabItem { Label("Ver Turno", systemImage: "list.bullet.rectangle") }
            .tag(TabID.ver)
            
            NavigationStack(path: $router.pathHora) {
                HoraPicoView()
            }
            .tabItem { Label("Hora Pico", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90") }
            .tag(TabID.hora)
            
            NavigationStack(path: $router.pathMap) {
                UserMap()
            }
            .tabItem { Label("Mapa", systemImage: "map.circle.fill") }
            .tag(TabID.Map)
            
            NavigationStack(path: $router.pathCall) {
                UserCallView()
            }
            .tabItem { Label("Llamada", systemImage: "phone") }
            .tag(TabID.Call)
            
            NavigationStack(path: $router.pathCita) {
                AppointmentHistoryView()
            }
            .tabItem { Label("Historial", systemImage: "document.on.clipboard") }
            .tag(TabID.Cita)
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
    
    
    func actualizarTurnos() async {
        // 🔹 Ejecuta la tarea con prioridad alta y fuera del actor principal
        await Task.detached(priority: .high) {
            do {
                let nuevosTurnos = try await fetchUserTurns(userId: idusuario)

                // 🔹 Vuelve al MainActor solo para actualizar el estado
                await MainActor.run {
                    // ✅ Solo actualiza si realmente hay cambios
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
        }.value // <- importante: espera el resultado de la tarea detachada
    }
}

    #Preview {
        UserCallView()
    }
