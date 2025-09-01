//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct TurnoView: View {
    var paciente: String
    var fecha: Date

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(Color.appPrimary)
            VStack(alignment: .leading) {
                Text(paciente).font(.headline)
                Text(fecha.formatted(date: .abbreviated, time: .shortened))
            }
            Spacer()
        }
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
