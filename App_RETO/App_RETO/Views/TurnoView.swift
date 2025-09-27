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
    @Binding var idusuario: Int

    @State private var hora = Date()
    @State private var numeroReceta = ""
    @State private var idReceta = ""
    @State private var comentario = ""
    
    @State private var mostrarDatePicker = false
    @EnvironmentObject var router: Router

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }

    var body: some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(spacing: 18) {
                    TurnoProfileImage(size: 120).padding(.top, 16)
                    Text(usuario).font(.title).bold().foregroundStyle(.orange).padding(.bottom,20)

                    sectionLabel("Escoge una hora")

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

                    sectionLabel("ID de usuario")
                    Text("\(idusuario)").font(.title3).padding(.bottom,20)
                    
                    HStack(spacing: 25) {
                        Button(action: {
                            router.selected = .dashboard
                            router.popToRoot(.dashboard)
                        }) {
                            HStack { Text("Cancelar").font(.system(size: 24, weight: .bold)) }
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .buttonStyle(.bordered)
                        .tint(Color.marca)

                        // 👇 BOTÓN MODIFICADO
                        BotonPrincipal(title: "Agendar") {
                            // Crear una tarea asíncrona para llamar a la API
                            Task {
                                let fechaFormateada = fechaCompletaConHoraSeleccionada(hora)
                                let response = try await createTurno(
                                    scheduledDate: fechaFormateada,
                                    prescriptionId: "RA001",
                                    comentariosReceta: "",
                                    usrId: idusuario
                                )
                                alertMessage = "Turno creado con ID \(response.newTurnoId)"
                            }
                            router.selected = .dashboard
                            router.popToRoot(.dashboard)
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
        // 👇 ALERTA MODIFICADA
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                // Si la operación fue exitosa, navega de regreso al dashboard
                if alertTitle == "Turno Creado" {
                    router.selected = .dashboard
                    router.popToRoot(.dashboard)
                }
            }
        } message: {
            Text(alertMessage)
        }
        .navigationTitle("Agendar turno")
        .navigationBarTitleDisplayMode(.inline)
        .navBarStyleGray()
    }
    
    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    TurnoView(usuario: .constant("Marco"), loggedIn: .constant(true), idusuario: .constant(8))
        .environmentObject(Router())
}






