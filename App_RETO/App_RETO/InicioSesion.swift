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
    private let validUser = "Olivervazquezz"
    private let validPass = "1234"
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 8) {
                    Image("LogoTurnoMed")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 215.0)
                }
                                                
                TextField("Usuario", text: $usuario)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Contraseña", text: $contrasena)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Iniciar Sesión") {
                    if usuario == validUser && contrasena == validPass {
                        loggedIn = true
                    } else {
                        showAlert = true
                    }
                }
                .bold()
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Usuario o contraseña incorrectos."), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $loggedIn) {
                ContentView()
            }
        }
    }
}

#Preview {
    InicioSesion()
}
