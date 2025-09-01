//
//  ContentView.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var loggedIn = false
    @State private var usuario = ""

    var body: some View {
        if loggedIn {
            UserTabs(usuario: usuario, loggedIn: $loggedIn)
        } else {
            InicioSesion(usuario: $usuario, loggedIn: $loggedIn)
        }
    }
}

#Preview {
    ContentView()
}
