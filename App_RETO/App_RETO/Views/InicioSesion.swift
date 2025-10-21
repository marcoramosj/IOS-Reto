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
    @Binding var idusuario: Int
    @State private var contrasena = ""
    @State private var showAlert = false
    @State private var idDeUsuario = 0
    @EnvironmentObject var router: Router
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                Image("LogoNova2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 215)
                
                TextField("Usuario", text: $usuario)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .padding()
                
                SecureField("Contraseña", text: $contrasena)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                
                BotonPrincipal(title: "Iniciar Sesión") {
                    Task {
                        do {
                            let result = try await fetchLogin(username: usuario, password: contrasena)
                            
                            if result.message.lowercased() == "true" {
                                loggedIn = true
                            
                                print("Login correcto para \(result.username ?? "")")
                            } else {
                                showAlert = true
                            }
                        } catch {
                            showAlert = true
                            print("Error en login:", error.localizedDescription)
                        }
                    }

                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Usuario o contraseña incorrectos."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview{
    InicioSesion(usuario: .constant(""), loggedIn: .constant(false), idusuario: .constant(0))
        .environmentObject(Router())
}
