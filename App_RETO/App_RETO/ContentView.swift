//
//  ContentView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//

import SwiftUI

// MARK: - Root with TabView (professor method)
struct ContentView: View {
    var body: some View {
        VStack {
            TabView {
                // 1) Dashboard
                DashboardScreen()
                    .tabItem {
                        Image(systemName: "house.circle")
                        Text("Home")
                    }

                // 2) Search (no examples)
                SearchTabView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }

                // 3) Alerts
                AlertsTabView()
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Alerts")
                    }
            }
            .onAppear {
                // Original orange tab bar look
                UITabBar.appearance().barTintColor = .orange
                UITabBar.appearance().backgroundColor = .orange
                UITabBar.appearance().unselectedItemTintColor = .black
            }
        }
        .tint(.white) // selected tab color
    }
}

#Preview { ContentView() }

// MARK: - Dashboard (with working cancel)
struct DashboardScreen: View {
    @State private var tabSel = 0
    @State private var showCancelAlert = false
    @State private var showUpcoming = false
    @State private var showMedication = false
    @State private var notifCount = 2
    @State private var appointmentDismissed = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Top bar
                HStack {
                    Text("Dashboard").font(.title3).foregroundStyle(.gray)
                    Spacer()
                    Button { notifCount = 0 } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bubble.left.and.bubble.right").font(.title2)
                            if notifCount > 0 {
                                Text("\(notifCount)")
                                    .font(.caption2).bold()
                                    .padding(4)
                                    .background(Circle().fill(.orange))
                                    .foregroundStyle(.white)
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                    Button { /* open profile */ } label: {
                        Circle().fill(.teal).frame(width: 36, height: 36)
                            .overlay(Image(systemName: "person.fill").foregroundStyle(.yellow))
                    }
                }

                // Greeting
                Text("Hello,\nExample Name 👋")
                    .font(.system(size: 36, weight: .bold))
                    .lineSpacing(2)

                // Segmented control
                Picker("", selection: $tabSel) {
                    Text("Overview").tag(0)
                    Text("Suggestions").tag(1)
                }
                .pickerStyle(.segmented)

                // Appointment card
                if !appointmentDismissed {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.darkGray))
                            .overlay(
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Up coming Appointment")
                                        .font(.title3).bold().foregroundStyle(.white)
                                    Text("Appointment on 8/09")
                                        .foregroundStyle(.white.opacity(0.9))
                                    Button("Cancelar Turno") { showCancelAlert = true }
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color(.systemTeal))
                                }
                                .padding()
                            )
                            .frame(height: 150)

                        Button { withAnimation { appointmentDismissed = true } } label: {
                            Image(systemName: "xmark")
                                .font(.caption.bold())
                                .padding(10)
                                .background(Circle().fill(.orange))
                                .foregroundStyle(.white)
                                .padding(10)
                        }
                    }
                    .alert("Cancel this appointment?", isPresented: $showCancelAlert) {
                        Button("Yes", role: .destructive) {
                            withAnimation(.easeInOut) { appointmentDismissed = true }
                        }
                        Button("No", role: .cancel) { }
                            .tint(.blue) // “No” is blue
                    }
                    .transition(.opacity.combined(with: .scale))
                }

                // Info cards
                DashRow(icon: "figure.walk", title: "Upcoming", value: "2", color: Color(.systemTeal)) {
                    showUpcoming = true
                }
                .sheet(isPresented: $showUpcoming) { UpcomingSheetView() }

                DashRow(icon: "drop.fill", title: "Total Medication", value: "8", color: Color(.systemBlue)) {
                    showMedication = true
                }
                .sheet(isPresented: $showMedication) { MedicationSheetView() }
            }
            .padding(20)
        }
        .background(
            LinearGradient(colors: [.white, .white.opacity(0.94)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

// MARK: - Search tab (no sample items)
struct SearchTabView: View {
    @State private var query = ""
    @State private var selectedItem: SearchItem? = nil
    @State private var showDetail = false

    // No examples; plug real data here later (or fetch)
    let allItems: [SearchItem] = []

    // Only show results when there is a query
    var filtered: [SearchItem] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return [] }
        return allItems.filter { $0.title.lowercased().contains(q) || $0.category.lowercased().contains(q) }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { item in
                Button {
                    selectedItem = item
                    showDetail = true
                } label: {
                    HStack {
                        Image(systemName: icon(for: item.category))
                            .frame(width: 24)
                        VStack(alignment: .leading) {
                            Text(item.title).font(.headline)
                            Text(item.category).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Search")
            .searchable(text: $query,
                        placement: .navigationBarDrawer,
                        prompt: "Search appointments or meds")
            .tint(.black) // Search bar “Cancel” text is black
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { query = "" } label: { Image(systemName: "xmark.circle") }
                        .disabled(query.isEmpty)
                }
            }
            // Helpful overlays
            .overlay {
                if query.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass.circle").font(.system(size: 44))
                        Text("Start typing to search").foregroundStyle(.secondary)
                    }
                } else if filtered.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "questionmark.circle").font(.system(size: 44))
                        Text("No matches for “\(query)”").foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showDetail) {
                if let item = selectedItem {
                    SearchDetailView(item: item)
                }
            }
        }
    }

    private func icon(for category: String) -> String {
        switch category.lowercased() {
        case "medication": return "pills.fill"
        case "appointment": return "calendar"
        case "lab": return "drop.triangle"
        default: return "magnifyingglass"
        }
    }
}

struct SearchItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let category: String
}

struct SearchDetailView: View {
    let item: SearchItem
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "info.circle.fill").font(.system(size: 48))
                Text(item.title).font(.title2.bold())
                Text(item.category).foregroundStyle(.secondary)
                Button("Close") { dismiss() }.buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Alerts tab
struct AlertsTabView: View {
    @State private var muted = false
    var body: some View {
        Form {
            Toggle("Mute notifications", isOn: $muted)
            Button("Test Alert") {
            }
        }
    }
}

// MARK: - Reusable dash row
struct DashRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color.opacity(0.2)).frame(width: 54, height: 54)
                    Image(systemName: icon).font(.title2).foregroundStyle(color)
                }
                Text(title).font(.title3).foregroundStyle(.white)
                Spacer()
                Text(value).bold().foregroundStyle(.white)
                Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.9))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(color))
            .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        }
    }
}

// MARK: - Sheets used by dashboard
struct UpcomingSheetView: View { var body: some View { Text("Upcoming list").font(.title)
    }
    
}
struct MedicationSheetView: View { var body: some View { Text("Medication list").font(.title)
    }
}
