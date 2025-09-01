//
//  TurnoViewOliver.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct VerTurnoView: View {
    @State private var title = "Agenda un turno"
    @State private var subtitle = "Example name"
    let usuario: String
    @Binding var loggedIn: Bool
    
    var body: some View {
        NavigationStack{
            
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    TurnoProfileImage(size: 44)
                }
                .overlay(Text(title).font(.title2).bold())
                .padding(.horizontal)
                .padding(.top, 6)
                
                ScrollView {
                    VStack(spacing: 18) {
                        TurnoProfileImage(size: 120)
                            .padding(.top, 16)
                        
                        Text(subtitle)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Text("Tu turno: ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(20)
                        Text("02")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(10)
                        Text("Ventanilla: ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(10)
                        Text("03")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(10)
                        Spacer()
                        HStack(spacing: 35) {
                            BotonPantallasSecundario(title: "Salir", pantalla: DashboardUserView(usuario: usuario, loggedIn: .constant(true)), color: .ColorBoton)
                            
                            
                        }
                        .padding(.bottom, 8)
                        .frame(width: .infinity)
                        Spacer()
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.pantallasColor)
                    )
                    .padding(.horizontal,40)
                   
                }
            }
            
        }
        
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VerTurnoView(usuario: "marcoramos", loggedIn: .constant(true))
}
