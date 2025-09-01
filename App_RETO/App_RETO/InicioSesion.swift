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
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing: 28) {
                Image("LogoTurnoMed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                    .padding(.top, 60)

                VStack(spacing: 16) {
                    TextField("Usuario", text: $usuario)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding()
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
                        .font(.title3)

                    SecureField("Contraseña", text: $contrasena)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
                        .font(.title3)
                }
                .padding(.horizontal, 28)

                AppButton(title: "Iniciar sesión") {
                    if usuario == validUser && contrasena == validPass { loggedIn = true } else { mostrarError = true }
                }
                .padding(.horizontal, 28)

                Spacer()
            }
        }
        .alert("Credenciales inválidas", isPresented: $mostrarError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Verifica tu usuario y contraseña")
        }
    }
}
