//
//  AgendarTurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct AgendarTurnoView: View {
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
                    .font(.title3)
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
                Button("Confirmar turno") {
                    confirmado = true
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
        }
        .font(.title3)
        .navigationTitle("Agendar")
        .alert("Turno confirmado", isPresented: $confirmado) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(especialidad) • \(fecha.formatted(date: .abbreviated, time: .shortened))")
        }
    }
}
