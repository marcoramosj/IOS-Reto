//
//  CalendarioFiltroView.swift
//  App_RETO
//
//  Created by Mauricio on 20/10/25.
//

import SwiftUI

struct CalendarioFiltroView: View {
    @Binding var selectedDays: Set<DateComponents>
    var bounds: Range<Date>?
    var maxSelection: Int = 2
    @Binding var fechaInicio: Date?
    @Binding var fechaFin: Date?

    @Environment(\.calendar) private var calendar
    @Environment(\.timeZone) private var timeZone
    @Environment(\.dismiss) private var dismiss

    @State private var previousSelection: Set<DateComponents> = []

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if let bounds {
                    MultiDatePicker("Fechas disponibles", selection: $selectedDays, in: bounds)
                        .padding(.horizontal)
                } else {
                    MultiDatePicker("Fechas disponibles", selection: $selectedDays)
                        .padding(.horizontal)
                }

                if !selectedDays.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sortedSelectedDates, id: \.self) { d in
                                Text(shortDay(d))
                                    .font(.caption)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(.thinMaterial)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .navigationTitle("Selecciona fechas")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        let sorted = sortedSelectedDates
                        if sorted.count >= 1 {
                            fechaInicio = sorted.first
                        }
                        if sorted.count >= 2 {
                            fechaFin = sorted.last
                        } else {
                            fechaFin = nil
                        }
                        dismiss()
                    }
                }

            }
            .presentationDetents([.medium, .large])
        }
        .onChange(of: selectedDays) { newValue in
            enforceCap(old: previousSelection, new: newValue)
            previousSelection = selectedDays
        }
        .onAppear { previousSelection = selectedDays }
    }


    private func enforceCap(old: Set<DateComponents>, new: Set<DateComponents>) {
        guard new.count > maxSelection else { return }

        let added = new.subtracting(old)
        if let justAdded = added.first {
            let justAddedDate = toStartOfDay(justAdded)
            let oldDates = old.compactMap { toStartOfDay($0) }

            let closest = oldDates.min(by: { abs($0.timeIntervalSince(justAddedDate)) < abs($1.timeIntervalSince(justAddedDate)) })

            var keep: [DateComponents] = [justAdded]
            if let closest, let comps = toComponents(closest) {
                keep.append(comps)
            }

            selectedDays = Set(keep)
        } else {
            let sorted = sortedSelectedDates.prefix(maxSelection)
            selectedDays = Set(sorted.compactMap { toComponents($0) })
        }
    }


    private var sortedSelectedDates: [Date] {
        selectedDays
            .compactMap { toStartOfDay($0) }
            .sorted()
    }

    private func toStartOfDay(_ comps: DateComponents) -> Date {
        var c = comps; c.timeZone = timeZone
        let d = calendar.date(from: c) ?? Date()
        return calendar.startOfDay(for: d)
    }

    private func toComponents(_ date: Date) -> DateComponents? {
        calendar.dateComponents(in: timeZone, from: date)
    }

    private func shortDay(_ date: Date) -> String {
        let fmt = DateFormatter(); fmt.dateFormat = "MMM d"
        return fmt.string(from: date)
    }
}

