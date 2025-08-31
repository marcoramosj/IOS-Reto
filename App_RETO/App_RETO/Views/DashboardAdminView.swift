//
//  DashboardAdminView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 27/08/25.
//
import SwiftUI

struct DashboardAdminView: View {
    var usuario: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Hola, \(usuario)")
                    .font(.largeTitle)
                    .bold()

                HStack(spacing: 12) {
                    card(numero: 2, titulo: "Próximas citas", icono: "calendar")
                    card(numero: 8, titulo: "Medicamentos", icono: "pills.fill")
                }

                NavigationLink("Agendar nuevo turno") {
                    AgendarTurnoView()
                }
                .font(.title3)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)

                Text("Hoy")
                    .font(.title2)
                    .padding(.top, 8)

                TurnoView(paciente: "Juan Pérez", fecha: Date().addingTimeInterval(3600))
                TurnoView(paciente: "Ana López", fecha: Date().addingTimeInterval(7200))
            }
            .padding()
        }
        .navigationTitle("Inicio")
    }

    private func card(numero: Int, titulo: String, icono: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(titulo, systemImage: icono)
                .font(.headline)
            Text("\(numero)")
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
