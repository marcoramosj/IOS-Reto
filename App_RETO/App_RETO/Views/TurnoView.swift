//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct TurnoView: View {
    @State private var title = "Agenda un turno"
    @State private var subtitle = "Example name"
    @Environment(\.dismiss) var dismiss
    @State private var hora = Date()
    @State private var numeroReceta = ""
    @State private var idReceta = ""
    @State private var comentario = ""
    
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
                    
                    sectionLabel("ESCOGE UN HORA")
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hora").font(.headline).foregroundStyle(Color.TextoColor)
                            Text(hora, style: .time)
                                    .foregroundColor(Color.TextoColor) 
                                    .font(.system(size: 20, weight: .bold))

                                DatePicker("", selection: $hora, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .frame(width: 0, height: 0)
                                    .clipped()
                        }
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundStyle(.orange)
                    }
                    
                    sectionLabel("NUMERO DE RECETA")
                        .foregroundStyle(Color.TextoColor)
                    TextField("Número", text: $numeroReceta)
                        .textFieldStyle(.roundedBorder)
                    
                    sectionLabel("ID de receta")
                        .foregroundStyle(Color.TextoColor)
                    TextField("ID", text: $idReceta)
                        .textFieldStyle(.roundedBorder)
                    
                    sectionLabel("COMENTARIOS EXTRA")
                        .foregroundStyle(Color.TextoColor)
                    TextField("Comentario", text: $comentario, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack(spacing: 12) {
                        Button("Salir") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.Buttoncolor)
                        .frame(maxWidth: .infinity)
                        
                        Button("Aceptar") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.Buttoncolor)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 8)
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
    TurnoView()
}
