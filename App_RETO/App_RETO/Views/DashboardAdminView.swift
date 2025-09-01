//
//  DashboardAdminView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 27/08/25.
//
import SwiftUI

struct DashboardAdminView: View {
    @EnvironmentObject var appState: AppState
    var usuario: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Hola, \(usuario)").font(.largeTitle).bold()

                HStack(spacing: 12) {
                    StatCard(icon: "calendar", title: "Próximas citas", value: "\(appState.citas.count)")
                    StatCard(icon: "pills.fill", title: "Medicamentos", value: "8")
                }

                AppButton(title: "Agendar nuevo turno") {
                    appState.selectedTab = 1          // <— te lleva al tab Agendar
                }

                Text("Hoy").font(.title2).padding(.top, 8)

                if appState.citas.isEmpty {
                    EmptyStateView(icon: "tray", title: "Sin turnos", message: "Aún no tienes turnos agendados.")
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(appState.citas.prefix(2)) { cita in
                        TurnoView(paciente: cita.paciente, fecha: cita.fecha)
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("Inicio")
    }
}
