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

                    Text(subtitle).font(.title3).bold()

                    sectionLabel("ESCOGE UN HORA")
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hora").font(.headline).foregroundStyle(.orange)
                            DatePicker("", selection: $hora, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .tint(.orange)
                        }
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundStyle(.orange)
                    }

                    sectionLabel("NUMERO DE RECETA")
                    TextField("Número", text: $numeroReceta)
                        .textFieldStyle(.roundedBorder)

                    sectionLabel("ID de receta")
                    TextField("ID", text: $idReceta)
                        .textFieldStyle(.roundedBorder)

                    sectionLabel("COMENTARIOS EXTRA")
                    TextField("Comentario", text: $comentario, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .textFieldStyle(.roundedBorder)

                    HStack(spacing: 12) {
                        Button("Salir") {
                            
                        }
                            .buttonStyle(.borderedProminent)
                            .tint(.teal)
                            .frame(maxWidth: .infinity)

                        Button("Aceptar") {
                            
                        }
                            .buttonStyle(.borderedProminent)
                            .tint(.teal)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 8)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThickMaterial)
                )
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.caption).bold()
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


private struct TurnoProfileImage: View {
    var size: CGFloat = 64
    var body: some View {
        ZStack {
            Circle().fill(.black)
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding(size * 0.22)
                .foregroundStyle(.orange)
        }
        .overlay(Circle().stroke(.orange, lineWidth: size * 0.06))
        .frame(width: size, height: size)
    }
}

#Preview {
    TurnoView()
}
