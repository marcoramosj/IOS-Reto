//
//  ConfiguracionView.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct ConfiguracionView: View {
    @Binding var loggedIn: Bool
    @State private var confirmar = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Cerrar sesión") {
                confirmar = true
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .background(Color(.red))
            .cornerRadius(12)
        }
        .navigationTitle("Configuración")
        .alert("¿Cerrar sesión?", isPresented: $confirmar) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar sesión", role: .destructive) {
                loggedIn = false
            }
        } message: {
            Text("Volverás a la pantalla de inicio.")
        }
    }
}

#Preview {
    ConfiguracionView(loggedIn: .constant(true))
}
