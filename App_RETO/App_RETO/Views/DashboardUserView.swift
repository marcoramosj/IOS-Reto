//
//  DashboardUserView.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct DashboardUserView: View {
    let usuario: String
    @Binding var loggedIn: Bool

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                EncabezadoUser(usuario: usuario)
                
                VStack(spacing: 12) {
                    Text("Tu turno:")
                        .font(.largeTitle)
                        .fontWeight(.heavy)

                    Text("02")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .monospacedDigit()

                    Text("Falta 1 turno para llegar al tuyo")
                        .font(.headline)
                        .fontWeight(.bold)

                    Text("Ventanilla asignada: 3")
                        .fontWeight(.bold)
                        .padding(.top, 8)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(.systemGray4)))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                
                // Botones de prueba
                VStack(spacing: 12) {
                    Button("Pedir turno") {
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button("Cancelar turno") {
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(.red)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DashboardUserView(usuario: "marcoramos", loggedIn: .constant(true))
}
