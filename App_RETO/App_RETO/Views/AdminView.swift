//
//  AdminView.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 27/08/25.
//

import SwiftUI

struct AdminView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Perfil") { ProfileImage(size: 140) }
                NavigationLink("Configuración") { Text("Configuración").font(.title3).padding() }
                NavigationLink("Acerca de") { Text("TurnoMed").font(.title3).padding() }
            }
            .navigationTitle("Perfil")
        }
    }
}
