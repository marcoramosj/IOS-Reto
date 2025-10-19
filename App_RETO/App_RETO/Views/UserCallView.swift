//
//  ContentView.swift
//  PruebLlamar
//
//  Created by 박진혁 on 15/10/25.
//


import SwiftUI

struct UserCallView: View {
    // MARK: - State
    @State private var calls: [CallRecord] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    @State private var showDeleteAlert = false
    @State private var callToDelete: CallRecord?

    private let phoneNumber = "+528117979687"
    private let userId = 1   // <- your current user id

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Call button
                Button {
                    if let url = URL(string: "tel://\(phoneNumber)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
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

                // Content
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
                                            Label("Eliminar", systemImage: "trash")
                                                .tint(Color.acento)
                                        }
                                    }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable { await loadCalls() }
                }
            }
            .navigationTitle("Llamada")
            .background(Color(.systemGroupedBackground))
            .task { await loadCalls() }
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

    // MARK: - Networking hooks into ModelData
    private func loadCalls() async {
        await MainActor.run { isLoading = true; errorMessage = nil }
        do {
            let list = try await loadUserCallsForUI(userId: userId)
            await MainActor.run {
                self.calls = list
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error al cargar llamadas: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    private func deleteCall(_ call: CallRecord) async {
        do {
            try await deleteCallFromUI(userId: userId, call: call)
            await MainActor.run {
                withAnimation { self.calls.removeAll { $0.id == call.id } }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "No se pudo eliminar la llamada: \(error.localizedDescription)"
            }
        }
    }
}

#Preview { UserCallView() }
