//
//  AgendarTurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct AgendarTurnoView: View {
    @EnvironmentObject var appState: AppState
    var paciente: String

    @State private var fecha = Date()
    @State private var especialidad = "Médico General"
    @State private var notas = ""
    @State private var confirmado = false

    let especialidades = ["Médico General", "Pediatría", "Dermatología", "Odontología"]

    var body: some View {
        Form {
            Section("Fecha y hora") {
                DatePicker("Selecciona", selection: $fecha, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .primaryText()
            }
            Section("Especialidad") {
                Picker("Área", selection: $especialidad) {
                    ForEach(especialidades, id: \.self) { Text($0) }
                }
                .pickerStyle(.navigationLink)
            }
            Section("Notas") {
                TextField("Escribe algo relevante", text: $notas, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
            Section {
                AppButton(title: "Confirmar turno") {
                    let cita = Cita(paciente: paciente, fecha: fecha, especialidad: especialidad, notas: notas)
                    appState.agregar(cita)
                    confirmado = true
                }
            }
        }
        .primaryText()
        .navigationTitle("Agendar")
        .alert("Turno confirmado", isPresented: $confirmado) {
            Button("Ver mis turnos") { appState.selectedTab = 2 }   // <— cambia a “Mis turnos”
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(especialidad) • \(fecha.formatted(date: .abbreviated, time: .shortened))")
        }
        .background(Color.appBackground)
    }
}
