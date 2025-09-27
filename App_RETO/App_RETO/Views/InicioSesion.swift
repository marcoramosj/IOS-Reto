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
    @State private var accesos: [AccesoUsuario] = []

    
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
                                    
                if let usuarioEncontrado = accesos.first(where: { $0.nombre == usuario && $0.password == contrasena }) {
                                        
                                        
                    loggedIn = true
                    idusuario = usuarioEncontrado.iduser
                                        
                    router.selected = .dashboard
                    router.popToRoot(.dashboard)
                                        
                                    } else {
                                        showAlert = true
                                    }
                                }
                .padding(.vertical, 18)
                .padding(.horizontal, 30)
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
        .onAppear {
            Task {
                do {
                    accesos = try await fetchUsuarios()
                } catch {
                    print("Error al obtener accesos: \(error)")
                }
                
            }
        }
        .onAppear {
            Task {
                do {
                    accesos = try await fetchUsuarios()
                    print("Usuarios desde API:")
                    for acceso in accesos {
                        print("nombre: \(acceso.nombre), pass: \(acceso.password), id: \(acceso.iduser)")
                    }
                } catch {
                    print("Error al obtener accesos: \(error)")
                }
            }
        }
    }
}

#Preview{
    InicioSesion(usuario: .constant(""), loggedIn: .constant(false), idusuario: .constant(0))
        .environmentObject(Router())
}
