//
//  AgendarTurnoView.swift
//  Proyecto_Avance
//
//  Created by ediaz205  on 8/27/25.
//

import SwiftUI

struct AgendarTurnoView: View {
    @EnvironmentObject var appState: AppState
    var paciente: String

    @State private var fecha = Date()
    @State private var especialidad = "Médico General"
    @State private var notas = ""
    @State private var confirmado = false

    private let especialidades = ["Médico General", "Pediatría", "Dermatología", "Odontología"]

    var body: some View {
<<<<<<< Updated upstream
        GeometryReader { proxy in
            let minH = proxy.size.height * 0.9
            ScrollView {
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppTheme.corner)
                            .fill(Color.appPanel)
                            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)

                        VStack(spacing: 22) {
                            VStack(spacing: 12) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.appPrimary, .appAccent],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 46, weight: .bold))
                                            .foregroundStyle(.white)
                                    )
                                Text(paciente.isEmpty ? "Example name" : paciente)
                                    .font(.title2).bold()
                                    .foregroundStyle(.white)
                            }

                            VStack(alignment: .leading, spacing: 18) {
                                HStack {
                                    Text("Hora").foregroundStyle(.white)
                                    Spacer()
                                    HStack(spacing: 10) {
                                        DatePicker("", selection: $fecha, displayedComponents: .date)
                                            .labelsHidden()
                                            .padding(.horizontal, 10).padding(.vertical, 8)
                                            .background(.white.opacity(0.12))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .tint(.appAccent)
                                        DatePicker("", selection: $fecha, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .padding(.horizontal, 10).padding(.vertical, 8)
                                            .background(.white.opacity(0.12))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .tint(.appAccent)
                                    }
                                }

                                HStack {
                                    Text("Especialidad").foregroundStyle(.white)
                                    Spacer()
                                    Picker("", selection: $especialidad) {
                                        ForEach(especialidades, id: \.self) { Text($0) }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(.appAccent)
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Comentario").foregroundStyle(.white)
                                    ZStack(alignment: .topLeading) {
                                        TextEditor(text: $notas)
                                            .frame(minHeight: 140)
                                            .padding(10)
                                            .scrollContentBackground(.hidden)
                                            .background(.white.opacity(0.12))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .foregroundStyle(.white)
                                        if notas.isEmpty {
                                            Text("Escribe un comentario")
                                                .foregroundStyle(.white.opacity(0.85))
                                                .padding(.horizontal, 18)
                                                .padding(.vertical, 16)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                            .environment(\.colorScheme, .dark)

                            HStack(spacing: 12) {
                                AppButton(title: "Salir", fill: false) {
                                    appState.selectedTab = 0
                                }
                                AppButton(title: "Aceptar") {
                                    let nombre = paciente.isEmpty ? "Paciente" : paciente
                                    let cita = Cita(paciente: nombre, fecha: fecha, especialidad: especialidad, notas: notas)
                                    appState.agregar(cita)
                                    confirmado = true
                                }
                            }
=======
        NavigationStack {
            ZStack (alignment: .leading) {
                
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
                            
>>>>>>> Stashed changes
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: minH)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground.ignoresSafeArea())
        }
        .navigationTitle("Agendar un turno")
        .alert("Turno confirmado", isPresented: $confirmado) {
            Button("Ver mis turnos") { appState.selectedTab = 2 }
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(especialidad) • \(fecha.formatted(date: .abbreviated, time: .shortened))")
        }
    }
}
