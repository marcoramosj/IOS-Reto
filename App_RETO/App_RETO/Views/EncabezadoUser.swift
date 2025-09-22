//
//  EncabezadoUser.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//
import SwiftUI

struct EncabezadoUser: View {
    let usuario: String
    var body: some View {
        Text("Hola, \(usuario)")
            .font(.largeTitle.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview { EncabezadoUser(usuario: "marcoramos") }
