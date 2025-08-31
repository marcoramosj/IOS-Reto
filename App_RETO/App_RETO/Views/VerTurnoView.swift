//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct VerTurnoView: View {
    struct Cita: Identifiable, Hashable {
        let id = UUID()
        let paciente: String
        let fecha: Date
    }

    @State private var citas: [Cita] = [
        Cita(paciente: "Juan Pérez", fecha: Date().addingTimeInterval(3600)),
        Cita(paciente: "Ana López", fecha: Date().addingTimeInterval(7200))
    ]

    var body: some View {
        List {
            ForEach(citas) { cita in
                TurnoView(paciente: cita.paciente, fecha: cita.fecha)
            }
            .onDelete { indexSet in
                citas.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Mis turnos")
        .font(.title3)
        .toolbar {
            EditButton()
        }
    }
}
