//
//  AppointmentHistoryView.swift
//  App_RETO
//
//  Created by Mauricio on 20/10/25.
//

import SwiftUI

struct AppointmentHistoryView: View {
    @Binding var idusuario: Int
    @Binding var usuario: String

    @State private var historial: [HistorialUs] = []
    @State private var loading = false
    @State private var errorMessage: String? = nil
    @State private var searchText = ""
    @State private var isSearching = false

    @State private var showFiltroFechas = false
    @State private var selectedDays: Set<DateComponents> = []
    @State private var fechaInicio: Date? = nil
    @State private var fechaFin: Date? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Buscar receta o comentario", text: $searchText)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding(.top, 20)

                    if loading {
                        Section {
                            HStack {
                                Spacer()
                                ProgressView("Cargando historial...")
                                    .padding()
                                Spacer()
                            }
                        }
                    } else if let errorMessage = errorMessage {
                        Section {
                            ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(errorMessage))
                                .listRowBackground(Color.clear)
                        }
                    } else if historialFiltrado.isEmpty {
                        Section {
                            ContentUnavailableView("Sin historial", systemImage: "calendar.badge.exclamationmark", description: Text("No se encontraron registros para mostrar."))
                                .listRowBackground(Color.clear)
                        }
                    } else {
                        Section {
                            ForEach(historialFiltrado, id: \.id) { appt in
                                NavigationLink(destination: HistorialDetallesView(appt: appt)) {
                                    row(for: appt)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Historial")
                .task {
                    await cargarHistorial()
                }

                // 🔹 Botón flotante (sin tocar)
                VStack(spacing: 18) {
                    FloatingCircleButton(systemName: "calendar") {
                        showFiltroFechas = true
                    }
                }
                .padding(.trailing, 26)
                .padding(.bottom, 26)
            }
        }
        .sheet(isPresented: $showFiltroFechas) {
            CalendarioFiltroView(
                selectedDays: $selectedDays,
                bounds: nil,
                maxSelection: 2,
                fechaInicio: $fechaInicio,
                fechaFin: $fechaFin
            )
            .presentationDetents([.medium, .large])
        }
    }

    func row(for appt: HistorialUs) -> some View {
        let isEntregado = appt.comentariosCancelacion?.trimmingCharacters(in: .whitespacesAndNewlines)
            .localizedCaseInsensitiveCompare("Entregado") == .orderedSame
        let statusFinal = appt.status || isEntregado

        return VStack(alignment: .leading, spacing: 6) {
            Text("Receta: \(appt.perscriptionId)")
                .font(.headline)

            Text("Estado: \(statusFinal ? "Completado" : "Pendiente")")
                .font(.subheadline)
                .foregroundColor(statusFinal ? .green : .secondary)

            Text("Fecha: \(appt.scheduledDate.formatted(.dateTime.day().month().year().hour().minute()))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }

    var historialFiltrado: [HistorialUs] {
        var resultado = historial

        if !searchText.isEmpty {
            resultado = resultado.filter {
                $0.perscriptionId.localizedCaseInsensitiveContains(searchText) ||
                ($0.comentariosReceta ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }

        if let inicio = fechaInicio, let fin = fechaFin {
            resultado = resultado.filter {
                $0.scheduledDate >= inicio && $0.scheduledDate <= fin
            }
        }

        return resultado
    }

    func cargarHistorial() async {
        loading = true
        errorMessage = nil
        do {
            historial = try await fetchHistorialUsuario(usuarioId: idusuario)
        } catch {
            errorMessage = "No se pudo cargar el historial: \(error.localizedDescription)"
        }
        loading = false
    }
}

#Preview {
    AppointmentHistoryView(idusuario: .constant(4), usuario: .constant("Mauricio"))
}
