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
    @State private var hora = Date()
    @State private var numeroReceta = ""
    @State private var idReceta = ""
    @State private var comentario = ""
    @State private var mostrarDatePicker = false
    @EnvironmentObject var router: Router

    var usuarioID: String {
        if let u = BasedeDatos.info.first(where: { $0.nombre == usuario }) { return u.id }
        return "ID no encontrado"
    }
    var recetaID: String {
        if let datos = BasedeDatos.usuarioR.first(where: { ($0[0] as? String) == usuarioID }) { return datos[2] as? String ?? "RID no encontrado" }
        return "RID no encontrado"
    }

    var body: some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(spacing: 18) {
                    TurnoProfileImage(size: 120).padding(.top, 16)
                    Text(usuario).font(.title).bold().foregroundStyle(.orange).padding(.bottom,20)

                    sectionLabel("Escoge un hora")

                    HStack {
                        VStack(alignment: .center, spacing: 6) {
                            sectionLabel("Hora")
                            DatePicker("", selection: $hora, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .scaleEffect(1.4)
                        }
                        Spacer()
                    }
                    .padding(.bottom,20)

                    sectionLabel(usuario)
                    Text(usuarioID).font(.title3).padding(.bottom,20)
                    sectionLabel("ID de receta").foregroundStyle(.gray)
                    Text(recetaID).font(.title3).padding(.bottom,40)

                    HStack(spacing: 25) {
                        Button(action:
                                {
                            router.selected = .dashboard
                            router.popToRoot(.dashboard)
                                }) {
                            HStack { Text("Cancelar").font(.system(size: 24, weight: .bold)) }
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                        }
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .buttonStyle(.bordered) // solo borde
                                .tint(Color.marca)      // color del borde y relleno de la figura
                

                        BotonPrincipal(title: "Agendar") {
                            router.selected = .ver
                            router.popToRoot(.ver)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.marca)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.white)
        .sheet(isPresented: $mostrarDatePicker) {
            VStack {
                Text("Selecciona la hora").font(.headline).padding()
                DatePicker("", selection: $hora, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                Button("Aceptar") { mostrarDatePicker = false }.padding()
            }
            .presentationDetents([.fraction(0.35)])
        }
        .navigationTitle("Agendar turno")
        .navigationBarTitleDisplayMode(.inline)
        .navBarStyleGray()
    }
}

#Preview {
    TurnoView(usuario: .constant("Marco"), loggedIn: .constant(true))
        .environmentObject(Router())
}

