//
//  ContentView.swift
//  PruebLlamar
//
//  Created by 박진혁 on 15/10/25.
//



import SwiftUI

struct UserCallView: View {
    // MARK: - Env
    @Environment(\.scenePhase) private var scenePhase

    // MARK: - State
    @State private var calls: [CallRecord] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    @State private var showDeleteAlert = false
    @State private var callToDelete: CallRecord?

    // MARK: - Picker data from backend
    @State private var destinations: [ActivityAPIRow] = []
    @State private var selectedIndex: Int? = nil
    @State private var isLoadingDestinations = false
    @State private var destinationsError: String?

    // Remember intent to log after returning from Phone
    @State private var pendingLog: (name: String, number: String)? = nil

    // Your signed-in user id
    private let userId = 1

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // MARK: Dropdown Card (drives from `destinations`)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selecciona destino:")
                        .font(.headline)
                        .padding(.horizontal)

                    Menu {
                        if destinations.isEmpty {
                            Button("Sin datos") { }.disabled(true)
                        } else {
                            ForEach(destinations.indices, id: \.self) { i in
                                Button(destinations[i].name) { selectedIndex = i }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedIndex.flatMap { destinations[$0].name } ?? "Selecciona un destino")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down").foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }

                // "Llamar" button
                Button { callTapped() } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                        Text("Llamar")
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
                .padding(.horizontal)
                .disabled(selectedIndex == nil || destinations.isEmpty)

                if isLoadingDestinations {
                    ProgressView("Cargando destinos…").padding(.horizontal)
                } else if let dErr = destinationsError {
                    Text("Error al cargar destinos: \(dErr)")
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }

                content
            }
            .navigationTitle("Llamada")
            .background(Color(.systemGroupedBackground))
            .task {
                await loadDestinations()
                await loadCalls()
            }
            .alert("Eliminar llamada", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) { callToDelete = nil }
                Button("Eliminar", role: .destructive) {
                    if let call = callToDelete {
                        Task { await deleteCall(call) }
                    }
                }
            } message: {
                if let call = callToDelete {
                    Text("¿Seguro que quieres eliminar la llamada con \(call.name)?")
                } else {
                    Text("¿Seguro que quieres eliminar esta llamada?")
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active, let toLog = pendingLog else { return }
                pendingLog = nil
                Task { await logAndRefresh(name: toLog.name, number: toLog.number) }
            }
        }
    }

    // MARK: - Extracted content
    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView("Cargando llamadas…").padding(.top, 40)
        } else if let err = errorMessage {
            Text(err)
                .foregroundStyle(.red)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        } else {
            List {
                Section("Historial de llamadas") {
                    ForEach(calls) { call in
                        row(call)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    callToDelete = call
                                    showDeleteAlert = true
                                } label: {
                                    Label("Eliminar", systemImage: "trash").tint(.red)
                                }
                            }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable { await loadCalls() }
        }
    }

    // MARK: - Row cell
    @ViewBuilder
    private func row(_ call: CallRecord) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(call.name).font(.headline)
                Text(call.date).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            if !call.duration.isEmpty {
                Text(call.duration).font(.caption).foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Actions

    /// Load the destinations for the picker from GET /api/activities/{caller_id}
    private func loadDestinations() async {
        await MainActor.run { isLoadingDestinations = true; destinationsError = nil }
        do {
            let rows = try await fetchCallDestinations(callerId: userId)

            // De-duplicate by (name, number) while keeping order
            var seen = Set<String>()
            let uniqueRows = rows.filter { row in
                let key = "\(row.name)|\(row.number)"
                if seen.contains(key) { return false }
                seen.insert(key)
                return true
            }

            await MainActor.run {
                self.destinations = uniqueRows
                self.selectedIndex = uniqueRows.isEmpty ? nil : 0
                self.isLoadingDestinations = false
            }
        } catch {
            await MainActor.run {
                self.isLoadingDestinations = false
                self.destinationsError = error.localizedDescription
                self.destinations = []
                self.selectedIndex = nil
            }
        }
    }

    /// User tapped "Llamar": open dialer and mark intent to log later
    private func callTapped() {
        guard let idx = selectedIndex, destinations.indices.contains(idx) else { return }
        let d = destinations[idx]
        pendingLog = (d.name, d.number)

        // NOTE: tel:// does not open on the iOS Simulator – test on a real device.
        if let url = URL(string: "tel://\(d.number)") {
            UIApplication.shared.open(url)
        }
    }

    /// After returning to app: POST to /api/historial-contacto and then reload history
    private func logAndRefresh(name: String, number: String) async {
        do {
            try await createHistorialContacto(callerId: userId, name: name, number: number, startedAt: Date())
            await loadCalls()
        } catch {
            await MainActor.run {
                errorMessage = "No se pudo registrar la llamada: \(error.localizedDescription)"
            }
        }
    }

    private func loadCalls() async {
        await MainActor.run { isLoading = true; errorMessage = nil }
        do {
            let list = try await loadUserCallsForUI(userId: userId)
            await MainActor.run {
                calls = list
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error al cargar llamadas: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    private func deleteCall(_ call: CallRecord) async {
        do {
            try await deleteCallFromUI(userId: userId, call: call)
            await MainActor.run {
                withAnimation { calls.removeAll { $0.id == call.id } }
            }
        } catch {
            await MainActor.run {
                errorMessage = "No se pudo eliminar la llamada: \(error.localizedDescription)"
            }
        }
    }
}

#Preview { UserCallView() }
