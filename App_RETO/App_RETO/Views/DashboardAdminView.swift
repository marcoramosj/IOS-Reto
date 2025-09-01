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
    @State private var showCancel = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Hola, \(usuario) 👋").font(.system(size: 32, weight: .bold))

                if let proxima = appState.proxima() {
                    AppointmentCard(
                        title: "Up coming Appointment",
                        subtitle: proxima.fecha.formatted(date: .abbreviated, time: .shortened),
                        cancel: { showCancel = true }
                    )
                } else {
                    AppointmentCard(title: "Sin turno próximo", subtitle: "Agenda uno para aparecer aquí", cancel: {})
                        .opacity(0.7)
                }

                AppButton(title: "Agendar nuevo turno") { appState.selectedTab = 1 }

                HStack(spacing: 12) {
                    StatCard(icon: "calendar", title: "Upcoming", value: "\(appState.citas.count)", fill: .appPrimary)
                    StatCard(icon: "pills.fill", title: "Total Medication", value: "8", fill: .appAccent)
                }

                if !appState.citas.isEmpty {
                    HStack {
                        Text("Próximos turnos").font(.title2).bold()
                        Spacer()
                        Button("Ver todos") { appState.selectedTab = 2 }.foregroundStyle(Color.appPrimary)
                    }

                    let proximos = appState.citas.sorted { $0.fecha < $1.fecha }.prefix(3)
                    VStack(spacing: 10) {
                        ForEach(proximos) { cita in
                            AppointmentListItem(cita: cita)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .alert("¿Cancelar el próximo turno?", isPresented: $showCancel) {
            Button("Sí, cancelar", role: .destructive) { appState.cancelarProxima() }
            Button("No", role: .cancel) {}
        }
    }
}

private struct AppointmentListItem: View {
    let cita: Cita
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.appPrimary, .appAccent], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                Image(systemName: "clock").foregroundStyle(.white).font(.system(size: 18, weight: .semibold))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(cita.especialidad).font(.headline)
                Text(cita.fecha.formatted(date: .abbreviated, time: .shortened)).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
