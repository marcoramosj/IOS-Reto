//
//  ContentView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSel = 0                // Overview / Suggestions
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
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.title2)
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
                    Button { /* profile opens */ } label: {
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
                                    Text("Appointment on 12/09")
                                        .foregroundStyle(.white.opacity(0.9))
                                    Button("Cancelar Turno") { showCancelAlert = true }
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color(.systemTeal))
                                }
                                .padding()
                                .foregroundStyle(.white)
                            )
                            .frame(height: 150)

                        Button {
                            appointmentDismissed = true
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption.bold())
                                .padding(10)
                                .background(Circle().fill(.orange))
                                .foregroundStyle(.white)
                                .padding(10)
                        }
                    }
                    .alert("Cancel this appointment?", isPresented: $showCancelAlert) {
                        Button("Yes", role: .destructive) { /* cancel logic */ }
                        Button("No", role: .cancel) { }
                    }
                }

                // Info cards
                DashRow(
                    icon: "figure.walk",
                    title: "Upcoming",
                    value: "2",
                    color: Color(.systemTeal)
                ) { showUpcoming = true }
                .sheet(isPresented: $showUpcoming) { UpcomingSheet() }

                DashRow(
                    icon: "drop.fill",
                    title: "Total Medication",
                    value: "8",
                    color: Color(.systemBlue)
                ) { showMedication = true }
                .sheet(isPresented: $showMedication) { MedicationSheet() }
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

// Reusable pill row
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
