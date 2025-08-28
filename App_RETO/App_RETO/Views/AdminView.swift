//
//  AdminView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 27/08/25.
//

import SwiftUI

struct AdminView: View {
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            VStack(spacing: 16) {
                Encabezado(saludo: "Modo Administrador", icono: "person.crop.circle.fill.badge.checkmark")
                VStack(spacing: 12) {
                    OpcionRapida(titulo: "Abrir / Cerrar ventanillas", subtitulo: "", icono: "lock.rectangle.stack.fill", color: Color.green, mostrarFlecha: true)
                    OpcionRapida(titulo: "Historial de ventanillas", subtitulo: "", icono: "clock.fill", color: Color.blue, mostrarFlecha: true)
                    OpcionRapida(titulo: "Interfaz de ventanilla", subtitulo: "", icono: "rectangle.stack.person.crop.fill", color: Color.pink, mostrarFlecha: true)
                }
                Spacer()
                Button {
                } label: {
                    Text("Administrador")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(radius: 6, y: 3)
                }
                .padding(.horizontal, 20)
                BarraInferior()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    AdminView()
}
