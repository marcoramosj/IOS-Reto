//
//  HistorialDetallesView.swift
//  App_RETO
//
//  Created by Mauricio on 20/10/25.
//

import SwiftUI

struct HistorialDetallesView: View {
    let appt: HistorialUs

    public var statusFinal: Bool {
            if let cancel = appt.comentariosCancelacion?.trimmingCharacters(in: .whitespacesAndNewlines),
               cancel.localizedCaseInsensitiveCompare("Entregado") == .orderedSame {
                return true
            }
            return appt.status
        }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                
                // --- Información principal ---
                Text("Receta: \(appt.perscriptionId)")
                    .font(.title2)
                    .bold()
                    .padding(.top, 4)

                Label("Fecha programada: \(longDate(appt.scheduledDate))",
                      systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Label("Estado: \(statusFinal ? "Completado" : "Pendiente")",
                      systemImage: statusFinal ? "checkmark.circle" : "clock")
                    .foregroundColor(statusFinal ? .green : .orange)

                Divider().padding(.vertical, 8)
                
                // --- Comentarios de la receta ---
                if let comentario = appt.comentariosReceta, !comentario.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Comentarios de la receta:")
                            .font(.headline)
                        Text(comentario)
                            .font(.body)
                            .padding(.top, 2)
                    }
                } else {
                    Text("Sin comentarios de receta.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                // --- Comentarios de cancelación (opcional) ---
                if let cancel = appt.comentariosCancelacion, !cancel.isEmpty {
                    Divider().padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Motivo de cancelación:")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(cancel)
                            .font(.body)
                            .padding(.top, 2)
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Detalles del historial")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Format helpers
    private func longDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "es_MX")
        fmt.dateStyle = .long
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }
}

#Preview {
    let mock = HistorialUs(
        id: 1,
        scheduledDate: Date(),
        perscriptionId: "RX1001",
        comentariosReceta: nil,
        status: false,
        comentariosCancelacion: "Paciente canceló el turno"
    )
    return HistorialDetallesView(appt: mock)
}
