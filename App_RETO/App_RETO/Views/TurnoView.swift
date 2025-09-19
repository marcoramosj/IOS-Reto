//
//  TurnoView.swift
//  Proyecto_Avance
//
//  Created by Alumno  on 8/27/25.
//

import SwiftUI

struct TurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @State private var title = "Agenda un turno"
    @Environment(\.dismiss) var dismiss
    @State private var hora = Date()
    @State private var numeroReceta = ""
    @State private var idReceta = ""
    @State private var comentario = ""
    @State private var mostrarDatePicker = false
    
    var body: some View {
        NavigationStack {
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
                        
                        Text(usuario)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.orange)
                        
                        sectionLabel("ESCOGE UN HORA")
                            .foregroundStyle(.gray)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Hora").font(.headline).foregroundStyle(.orange)
                                Text(hora, style: .time)
                                    .foregroundColor(.orange)
                                    .font(.system(size: 20, weight: .bold))
                            }
                            Spacer()
                            Button {
                                mostrarDatePicker = true
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(.title3)
                                        .foregroundStyle(.orange)
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        
                        sectionLabel("\(usuario)")
                            .foregroundStyle(.gray)
                        TextField("Número", text: $numeroReceta)
                            .textFieldStyle(.roundedBorder)
                        
                        sectionLabel("ID de receta")
                            .foregroundStyle(.gray)
                        TextField("ID", text: $idReceta)
                            .textFieldStyle(.roundedBorder)
                        
                        sectionLabel("COMENTARIOS EXTRA")
                            .foregroundStyle(.gray)
                        TextField("Comentario", text: $comentario, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                        
                        HStack(spacing: 35) {
                            BotonSecundario(title:"Cancelar") {
                                dismiss()
                            }.tint(Color.ColorBoton)
                            
                            BotonPantallasSecundario(title: "Agendar", pantalla: VerTurnoView(usuario:$usuario , loggedIn: $loggedIn), color: .ColorBoton)
                        }
                        .padding(.bottom, 8)
                    }
                    .padding(20)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
            .background(Color.white)
            .sheet(isPresented: $mostrarDatePicker) {
                VStack {
                    Text("Selecciona la hora")
                        .font(.headline)
                        .padding()
                    
                    DatePicker("", selection: $hora, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                    
                    Button("Aceptar") {
                        mostrarDatePicker = false
                    }
                    .padding()
                }
                .presentationDetents([.fraction(0.35)])
            }
        }
    }
}

#Preview {
    TurnoView(usuario:.constant("Usuario"), loggedIn: .constant(true))
}
