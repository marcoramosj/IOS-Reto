//
//  AppointmentHistoryView.swift
//  App_RETO
//
//  Created by Mauricio on 17/10/25.
//

import SwiftUI

// MARK: - Model

struct Appointment: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let place: String
    let date: Date
    let durationMinutes: Int
    let notes: String?
}

// MARK: - Mock (hardcoded) data

private extension Array where Element == Appointment {
    static var hardcodedPastWeek: [Appointment] {
        func daysAgo(_ d: Int, hour: Int = 10, minute: Int = 0) -> Date {
            var comps = DateComponents()
            comps.day = -d; comps.hour = hour; comps.minute = minute
            return Calendar.current.date(byAdding: comps, to: Date()) ?? Date()
        }

        return [
            Appointment(title: "Ventanilla 1",
                        place: "Clínica Nova • Ventanilla 1",
                        date: daysAgo(1, hour: 9, minute: 35),
                        durationMinutes: 20,
                        notes: "Chequeo rápido"),
            Appointment(title: "Ventanilla 2",
                        place: "Clínica Nova • Ventanilla 3",
                        date: daysAgo(2, hour: 14, minute: 10),
                        durationMinutes: 15,
                        notes: nil),
            Appointment(title: "Ventanilla 3 de Laboratorio",
                        place: "Clínica Nova • Ventanilla 2",
                        date: daysAgo(3, hour: 11, minute: 45),
                        durationMinutes: 25,
                        notes: "Todo en orden"),
            Appointment(title: "Consulta Nutricional",
                        place: "Clínica Nova • Ventanilla 4",
                        date: daysAgo(5, hour: 16, minute: 5),
                        durationMinutes: 30,
                        notes: nil),
            Appointment(title: "Control de Presión",
                        place: "Clínica Nova • Ventanilla 1",
                        date: daysAgo(6, hour: 8, minute: 50),
                        durationMinutes: 10,
                        notes: "Seguimiento"),
            Appointment(title: "Control de Presión",
                        place: "Clínica Nova • Ventanilla 1",
                        date: daysAgo(7, hour: 12, minute: 6),
                        durationMinutes: 10,
                        notes: "Seguimiento"),
            Appointment(title: "Control de Presión",
                        place: "Clínica Nova • Ventanilla 1",
                        date: daysAgo(7, hour: 2, minute: 40),
                        durationMinutes: 10,
                        notes: "Seguimiento")
        ]
    }
}

// MARK: - View (Week filter + Floating search button)

struct AppointmentHistoryView: View {
    // Week filter state (start-of-week, locale-aware)
    @State private var selectedWeekStart: Date? = nil

    // Search state
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false

    private let items: [Appointment]

    init(items: [Appointment] = .hardcodedPastWeek) {
        self.items = items.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Main content
                if filteredItems.isEmpty {
                    ContentUnavailableView(
                        "No hay citas para la semana seleccionada",
                        systemImage: "calendar",
                        description: Text("Prueba con otra semana o cambia el término de búsqueda.")
                    )
                    .navigationTitle("Historial")
                } else {
                    List {
                        ForEach(groupedByDayKeys, id: \.self) { day in
                            Section(header: Text(dayTitle(day))) {
                                ForEach(groupedByDay[day] ?? [], id: \.self) { appt in
                                    NavigationLink {
                                        AppointmentDetailView(appt: appt)
                                    } label: {
                                        row(appt).contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("Historial")
                    .toolbar {
                        // Week filter menu (right of title)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Picker(
                                    "Filter by Week",
                                    selection: Binding(
                                        get: { selectedWeekStart ?? mostRecentWeekStart },
                                        set: { selectedWeekStart = $0 }
                                    )
                                ) {
                                    ForEach(availableWeekStarts, id: \.self) { ws in
                                        Text(weekLabel(for: ws)).tag(ws as Date?)
                                    }
                                }
                            } label: {
                                Label("Filter", systemImage: "calendar.badge.clock")
                            }
                        }

                        // Count label
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Text("\(filteredItems.count) total")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Floating search button (black circle)
                Button {
                    withAnimation(.spring()) { isSearching.toggle() }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)

                // Slide-down search bar overlay
                if isSearching {
                    VStack {
                        HStack {
                            TextField("Buscar título, lugar o nota", text: $searchText)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .onSubmit { withAnimation { isSearching = false } }

                            Button {
                                withAnimation { isSearching = false }
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 10)
                            }
                        }
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            if selectedWeekStart == nil { selectedWeekStart = mostRecentWeekStart }
        }
    }

    // MARK: - Calendar helpers

    private var calendar: Calendar {
        var cal = Calendar.current
        // Force Monday start if you prefer: cal.firstWeekday = 2
        return cal
    }

    private func startOfWeek(for date: Date) -> Date {
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: comps) ?? calendar.startOfDay(for: date)
    }

    private func endOfWeek(for start: Date) -> Date {
        calendar.date(byAdding: .day, value: 6, to: start) ?? start
    }

    private var availableWeekStarts: [Date] {
        let set = Set(items.map { startOfWeek(for: $0.date) })
        return set.sorted(by: >) // most recent first
    }

    private var mostRecentWeekStart: Date {
        availableWeekStarts.first ?? startOfWeek(for: Date())
    }

    private func weekLabel(for weekStart: Date) -> String {
        let weekEnd = endOfWeek(for: weekStart)
        let short = DateFormatter()
        short.dateFormat = "MMM d"
        let y = DateFormatter()
        y.dateFormat = "yyyy"
        return "\(short.string(from: weekStart))–\(short.string(from: weekEnd)), \(y.string(from: weekStart))"
    }

    // MARK: - Filtering (week + search)

    private var filteredByWeek: [Appointment] {
        guard let ws = selectedWeekStart ?? availableWeekStarts.first else { return [] }
        let we = endOfWeek(for: ws)
        let startDay = calendar.startOfDay(for: ws)
        let endDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: we) ?? we
        return items.filter { $0.date >= startDay && $0.date <= endDay }
    }

    private var filteredItems: [Appointment] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return filteredByWeek }
        return filteredByWeek.filter { a in
            a.title.localizedCaseInsensitiveContains(q) ||
            a.place.localizedCaseInsensitiveContains(q) ||
            (a.notes?.localizedCaseInsensitiveContains(q) ?? false)
        }
    }

    // MARK: - Grouping

    private var groupedByDay: [Date: [Appointment]] {
        let groups = Dictionary(grouping: filteredItems) { appt -> Date in
            calendar.startOfDay(for: appt.date)
        }
        return groups.mapValues { $0.sorted { $0.date > $1.date } }
    }

    private var groupedByDayKeys: [Date] {
        groupedByDay.keys.sorted(by: >)
    }

    // MARK: - Row

    private func row(_ a: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(a.title).font(.headline)
                Spacer()
                Text(shortTime(a.date))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(a.place)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Label("\(a.durationMinutes) min", systemImage: "timer")
                if let notes = a.notes, !notes.isEmpty {
                    Divider().frame(height: 14)
                    Label(notes, systemImage: "note.text").lineLimit(1)
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.top, 0)
        }
        .padding(.vertical, 1)
    }

    // MARK: - Formatting

    private func dayTitle(_ date: Date) -> String {
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        let fmt = DateFormatter(); fmt.dateFormat = "EEE, MMM d"
        return fmt.string(from: date)
    }

    private func shortTime(_ date: Date) -> String {
        let fmt = DateFormatter(); fmt.timeStyle = .short; fmt.dateStyle = .none
        return fmt.string(from: date)
    }
}

// MARK: - Detail Screen

struct AppointmentDetailView: View {
    let appt: Appointment

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(appt.title).font(.title2).bold().padding(.top, 4)

                Label(appt.place, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Label(longDate(appt.date), systemImage: "calendar")
                    Label(shortTime(appt.date), systemImage: "clock")
                    Label("\(appt.durationMinutes) min", systemImage: "timer")
                }
                .padding(.top, 2)

                if let notes = appt.notes, !notes.isEmpty {
                    Divider().padding(.vertical, 6)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notas").font(.headline)
                        Text(notes).font(.body)
                    }
                }

                Spacer(minLength: 8)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func longDate(_ date: Date) -> String {
        let fmt = DateFormatter(); fmt.dateStyle = .full; fmt.timeStyle = .none
        return fmt.string(from: date)
    }
    private func shortTime(_ date: Date) -> String {
        let fmt = DateFormatter(); fmt.timeStyle = .short; fmt.dateStyle = .none
        return fmt.string(from: date)
    }
}

// MARK: - Preview

struct AppointmentHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentHistoryView()
    }
}
