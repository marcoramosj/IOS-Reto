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
                HStack(spacing: 12) {
                    Image(systemName: "calendar.circle.fill").font(.largeTitle).foregroundStyle(Color.appPrimary)
                    VStack(alignment: .leading) {
                        Text(cita.paciente).font(.headline)
                        Text(cita.fecha.formatted(date: .abbreviated, time: .shortened)).foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .onDelete { appState.citas.remove(atOffsets: $0) }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Mis turnos")
    }
}
