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
    @State private var showAlert = false
    
    // Credenciales fijas
    private let validUser = "marcoramos"
    private let validPass = "1234"
    
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                Image("LogoTurnoMed")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 215.0)
            }
            
            TextField("Usuario", text: $usuario)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .padding()
            
            SecureField("Contraseña", text: $contrasena)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
            
            Button("Iniciar Sesión") {
                if usuario == validUser && contrasena == validPass {
                    loggedIn = true
                } else {
                    showAlert = true
                }
            }
            .bold()
            .padding(.vertical, 18)
            .padding(.horizontal, 30)
            .background(Color.ColorBoton)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.top)
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Usuario o contraseña incorrectos."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    InicioSesion(usuario: .constant(""), loggedIn: .constant(false))
}
