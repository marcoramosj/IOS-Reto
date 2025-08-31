//
//  ContentView.swift
//  Reto
//
//  Created by Alumno on 27/08/25.
//

import SwiftUI

struct InicioSesion: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @State private var contrasena = ""
    @State private var mostrarError = false

    private let validUser = "marcoramos"
    private let validPass = "1234"

    var body: some View {
        VStack(spacing: 20) {
            Image("LogoTurnoMed")
                .resizable()
                .scaledToFit()
                .frame(width: 220)

            VStack(spacing: 12) {
                TextField("Usuario", text: $usuario)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                SecureField("Contraseña", text: $contrasena)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Button("Iniciar sesión") {
                if usuario == validUser && contrasena == validPass {
                    loggedIn = true
                } else {
                    mostrarError = true
                }
            }
            .font(.title3)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .font(.title3)
        .alert("Credenciales inválidas", isPresented: $mostrarError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Verifica tu usuario y contraseña")
        }
    }
}
