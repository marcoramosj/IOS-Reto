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
    @State private var alerta: Bool = false

    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    EncabezadoUser(usuario: usuario)
                    
                    VStack(spacing: 12) {
                        Text("Tu turno:")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                        
                        Text("02")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .monospacedDigit()
                            .foregroundStyle(.white)
                        
                        Text("Falta 1 turno para llegar al tuyo")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("Ventanilla asignada: 3")
                            .fontWeight(.bold)
                            .padding(.top, 8)
                            .foregroundStyle(.white)
                        
                        BotonPrincipal(title:"Cancelar turno"){
                            alerta=true
                        }.alert(isPresented: $alerta) {
                            Alert(
                                title: Text("Seguro?"),
                                message: Text("¿Quieres cancelar tu turno?"),
                                primaryButton: .default(Text("Continuar")) {
                                    print("Turno Cancelado")
                                },
                                secondaryButton: .cancel()
                            )
                        }
                            .tint(Color.ColorBoton)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color.pantallasColor))
                    .padding(.horizontal, 20)
                    
                    VStack(alignment:.leading, spacing: 12) {
                        BotonPantallas(title: "Pedir turno", pantalla: TurnoView(), color: .ColorBoton)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    DashboardUserView(usuario: "marcoramos", loggedIn: .constant(true))
}
