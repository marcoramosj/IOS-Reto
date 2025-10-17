//
//  ContentView.swift
//  PruebLlamar
//
//  Created by Diego Saldaña on 15/10/25.
//


import SwiftUI

struct UserCallView: View {
    let phoneNumber = "+528117979687"
    
    // Hardcoded call history
    let callHistory: [CallRecord] = [
        CallRecord(name: "Farmacia Nova", date: "16 Oct 2025, 10:12 AM", duration: "2m 15s"),
        CallRecord(name: "Clínica Nova", date: "15 Oct 2025, 6:45 PM", duration: "1m 03s"),
        CallRecord(name: "Farmacia Nova", date: "14 Oct 2025, 12:22 PM", duration: "3m 47s"),
        CallRecord(name: "Soporte Técnico", date: "12 Oct 2025, 9:08 AM", duration: "0m 56s")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Button {
                            if let phoneURL = URL(string: "tel://\(phoneNumber)") {
                                UIApplication.shared.open(phoneURL)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Llamar")
                            }
                        }
                    }
                    
                    // History Section
                    Section(header: Text("Historial de llamadas")) {
                        ForEach(callHistory) { call in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(call.name)
                                        .font(.headline)
                                    Text(call.date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(call.duration)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Llamada")
        }
    }
}

// Struct model for call history
struct CallRecord: Identifiable {
    let id = UUID()
    let name: String
    let date: String
    let duration: String
}

#Preview {
    UserCallView()
}
