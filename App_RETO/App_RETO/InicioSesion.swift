//
//  ContentView.swift
//  Reto
//
//  Created by Alumno on 27/08/25.
//

import SwiftUI

struct InicioSesion: View {
    
    @State private var usuario = ""
    @State private var contrasena = ""
    @State private var showAlert = false
    @State private var loggedIn = false
    
    // Credenciales fijas
    private let validUser = "marcoramos"
    private let validPass = "1234"
    
    var body: some View {
        NavigationStack {
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
                .padding(15)
                .background(Color(red: 0.012, green: 0.562, blue: 0.734))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.top)
                
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Usuario o contraseña incorrectos."), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $loggedIn) {
                BarraInferior()
            }
        }
    }
}

#Preview {
    InicioSesion()
}
