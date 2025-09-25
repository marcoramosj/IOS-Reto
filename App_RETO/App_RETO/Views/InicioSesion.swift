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
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                Image("LogoTurnoMed")
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
                    if BasedeDatos.info.contains(where: { $0.nombre == usuario && $0.clave == contrasena }) {
                        loggedIn = true
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
            AsyncImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl1y9z7yJ6BIFLSNMZyGCPzR1QlIGHjncBYg&s")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60) // tamaño pequeño
                                .padding()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Usuario o contraseña incorrectos."), dismissButton: .default(Text("OK")))
                    }
                }
}

#Preview{
    InicioSesion(usuario: .constant(""), loggedIn: .constant(false))
        .environmentObject(Router())
}
