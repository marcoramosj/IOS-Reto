//
//  Tabs.swift
//  
//
//  Created by 박진혁 on 8/28/25.
//

import SwiftUI

struct RecordsView: View {
    @State private var showNew = false
    var body: some View {
        VStack(spacing: 16) {
            Text("Records").font(.largeTitle.bold())
            Button("Add Record") { showNew = true }
                .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showNew) { AddItemSheet() }
    }
}

struct NotificationsView: View {
    @State private var muted = false
    var body: some View {
        Form {
            Toggle("Mute notifications", isOn: $muted)
            Button("Test Alert") { /* send test */ }
        }
        .navigationTitle("Alerts")
    }
}

// Sheets
struct UpcomingSheet: View { var body: some View { Text("Upcoming list").font(.title) } }
struct MedicationSheet: View { var body: some View { Text("Medication list").font(.title) } }
struct AddItemSheet: View { var body: some View {
    VStack(spacing: 12) {
        Text("Create").font(.title.bold())
        Button("Save") { /* save */ }.buttonStyle(.borderedProminent)
        Button("Close") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil) }
    }.padding()
}}
