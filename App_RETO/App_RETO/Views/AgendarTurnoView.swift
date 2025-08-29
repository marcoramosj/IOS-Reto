//
//  AgendarTurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct AgendarTurnoView: View {

    // Variables
    @State private var fechaYhora = Date()
    @State private var noReceta: String = ""
    @State private var comentarios: String = ""
    
    // Estados para Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDialog = false
    @State private var dialogMessage = ""

    var body: some View {
        NavigationStack {
            ZStack (alignment: .leading) {
                TurnoView(title: "Agenda tu turno", subtitle: "Ej. Nombre")
                
                // Create elements
                VStack (alignment: .center){
                    
                    VStack (alignment: .leading){
                        Text("Escoge tu horario de atención")
                            .font(.title3)
                            .padding(.bottom, 15)
                        
                        DatePicker("Escoge tu tiempo y hora", selection: $fechaYhora, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact) // options: .compact, .wheel, .graphical
                            .labelsHidden()
                            .padding(.leading, 5)
                            .padding(.bottom, 15)
                        
                        Text("Número de receta")
                            .padding(.bottom, 5)
                        TextField("Enter text here", text: $noReceta)
                            .padding(.leading, 5)
                            .padding(.bottom, 15)
                        
                        HStack{
                            
                        }
                        Text("Comentarios adicionales")
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    
                    
                    
                    TextEditor(text: $comentarios)
                        .frame(height: 80)  // height of the box
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                        
                    
                    // Botón "Salir"
                    Button(action: {
                    }) {
                        Text("Cancelar")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Botón "Salir"
                    Button(action: {
                        if noReceta.trimmingCharacters(in: .whitespaces).isEmpty {
                            alertMessage = "Error: Debes ingresar un No. de receta."
                            showAlert = true
                        } else if fechaYhora < Date() {
                            alertMessage = "Error: Debes seleccionar un horario de atención válido."
                            showAlert = true
                        } else if fechaYhora > Date() && !noReceta.trimmingCharacters(in: .whitespaces).isEmpty {
                            showDialog = true
                            dialogMessage = "¿Deseas confirmar tu turno?"
                        }
                    }) {
                        Text("Aceptar")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 20)
                    
                    
                }
                
                .padding(.top, 290)
                
                NavigationLink("Volver"){
                }
                .ignoresSafeArea(edges: .top)
                .padding(.bottom, 705)
                .padding(.leading)
                
                
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .confirmationDialog(dialogMessage,
                            isPresented: $showDialog,
                            titleVisibility: .visible) {
            Button("Aceptar") {
                print("Ver Turno")
                
                NavigationLink(destination: VerTurnoView()) {
                    EmptyView()
                }
                
                
            }
            Button("Cancelar", role: .cancel) { }
        }
    }
}


#Preview {
    AgendarTurnoView()
}

