//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct VerTurnoView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        List {
            ForEach(appState.citas) { cita in
                TurnoView(paciente: cita.paciente, fecha: cita.fecha)
            }
            .onDelete { indexSet in
                appState.citas.remove(atOffsets: indexSet)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Mis turnos")
        .primaryText()
        .toolbar { EditButton() }
    }
}
