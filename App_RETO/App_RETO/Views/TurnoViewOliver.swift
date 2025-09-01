//
//  TurnoViewOliver.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct TurnoViewOliver: View {
    @State private var title = "Agenda un turno"
    @State private var subtitle = "Example name"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                        BotonSecundario(title:"Salir") {
                            dismiss()
                        }.tint(Color.ColorBoton)
                        
                        
                        
                    }
                    
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.pantallasColor)
                )
                .padding(.horizontal)
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    TurnoViewOliver()
}
