//
//  ContentView.swift
//  PruebLlamar
//
//  Created by 박진혁 on 15/10/25.
//



import SwiftUI

// Local model for the picker (renamed to avoid collisions)
fileprivate struct DialDestination: Identifiable, Equatable {
    let id: Int          // Contacto_Id
    let name: String     // Display name
    let number: String   // Phone to dial
}

struct UserCallView: View {
    // You said you already keep these:
    @Binding var idusuario: Int
    @State private var actividadContactos: [Activity] = []      // /api/activities/{caller_id}
    @State private var listaContactos: [ListaContactos] = []    // /api/contactos

    @Environment(\.scenePhase) private var scenePhase

    // Picker state
    @State private var destinos: [DialDestination] = []
    @State private var selectedIndex: Int? = nil
    @State private var loadingDestinos = false
    @State private var destinosError: String?

    // History state
    @State private var loadingHistory = false
    @State private var historyError: String?

    // Remember what to log after returning from Phone
    @State private var pendingDestino: DialDestination?

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {

                // MARK: Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selecciona destino:")
                        .font(.headline)
                        .padding(.horizontal)

                    Menu {
                        if destinos.isEmpty {
                            Button("Sin datos"){}.disabled(true)
                        } else {
                            ForEach(destinos.indices, id: \.self) { i in
                                Button(destinos[i].name) { selectedIndex = i }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedIndex.flatMap { destinos[$0].name } ?? "Selecciona un destino")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down").foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }

                    Button(action: callTapped) {
                        HStack(spacing: 8) {
                            Image(systemName: "phone.fill")
                            Text("Llamar")
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    }
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                    .padding(.horizontal, 16)
                    .disabled(selectedIndex == nil || destinos.isEmpty)
                }

                // Picker error/loading
                if loadingDestinos {
                    ProgressView("Cargando destinos…").padding(.horizontal)
                } else if let err = destinosError {
                    Text("Error al cargar destinos: \(err)")
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }

                // MARK: History
                Group {
                    if loadingHistory {
                        ProgressView("Cargando historial…").padding(.top, 8)
                    } else if let hErr = historyError {
                        Text(hErr)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            Section("Historial de contactos") {
                                ForEach(actividadContactos) { a in
                                    historyRow(a)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .refreshable { await loadHistory() }
                    }
                }
            }
            .navigationTitle("Llamada")
            .background(Color(.systemGroupedBackground))
            .task {
                await loadDestinos()
                await loadHistory()
            }
            // Single-argument version for your toolchain
            .onChange(of: scenePhase) { newPhase in
                guard newPhase == .active, let d = pendingDestino else { return }
                pendingDestino = nil
                Task { await logAndRefresh(d) }
            }
        }
    }

    // MARK: UI Row
    @ViewBuilder
    private func historyRow(_ a: Activity) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(a.contactoNombreCompleto).font(.headline)
            Text(a.fechaContacto).font(.subheadline).foregroundColor(.secondary)
            HStack(spacing: 8) {
                Text(a.tipoContacto).font(.caption)
                if !a.numeroLlamado.isEmpty {
                    Text(a.numeroLlamado).font(.caption2).foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: Data Loading

    /// 🔁 Picker now loads ONLY from GET /api/contactos
    private func loadDestinos() async {
        await MainActor.run { loadingDestinos = true; destinosError = nil }
        do {
            // Always fetch /api/contactos for the picker
            listaContactos = try await fetchListaContactos()

            // Map -> DialDestination, skip contacts without phone
            var items: [DialDestination] = listaContactos.compactMap { c in
                let phone = c.telefono.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !phone.isEmpty else { return nil }
                let full = displayName(for: c)
                return DialDestination(id: c.id, name: full, number: phone)
            }

            // De-duplicate by phone (keep first)
            var seen = Set<String>()
            items = items.filter { seen.insert($0.number).inserted }

            // Sort alphabetically
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

            await MainActor.run {
                destinos = items
                selectedIndex = items.isEmpty ? nil : 0
                loadingDestinos = false
            }
        } catch {
            await MainActor.run {
                destinosError = error.localizedDescription
                destinos = []
                selectedIndex = nil
                loadingDestinos = false
            }
        }
    }

    private func loadHistory() async {
        await MainActor.run { loadingHistory = true; historyError = nil }
        do {
            let acts = try await fetchActivities(for: idusuario)
            await MainActor.run {
                actividadContactos = acts
                loadingHistory = false
            }
        } catch {
            await MainActor.run {
                historyError = "Error al cargar llamadas: \(error.localizedDescription)"
                actividadContactos = []
                loadingHistory = false
            }
        }
    }

    // MARK: Actions

    private func callTapped() {
        guard let idx = selectedIndex, destinos.indices.contains(idx) else { return }
        let d = destinos[idx]
        pendingDestino = d

        // tel:// won't open on Simulator
        if let url = URL(string: "tel://\(d.number)") {
            UIApplication.shared.open(url)
        }
    }

    private func logAndRefresh(_ d: DialDestination) async {
        do {
            let req = HistorialContactoRequest(callerId: idusuario,
                                               contactoId: d.id,
                                               tipoContacto: "Llamada")
            _ = try await postHistorialContacto(req)
            await loadHistory()
        } catch {
            await MainActor.run {
                historyError = "No se pudo registrar la llamada: \(error.localizedDescription)"
            }
        }
    }

    // MARK: Helpers

    private func displayName(for c: ListaContactos) -> String {
        [c.name, c.middleName, c.lastName, c.lastName1]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

#Preview { UserCallView(idusuario: .constant(8)) }
