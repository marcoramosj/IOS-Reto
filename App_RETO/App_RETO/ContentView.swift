//
//  ContentView.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usuario = ""
    @State private var loggedIn = false

    var body: some View {
        if loggedIn {
            DashboardUserView(usuario: $usuario, loggedIn: $loggedIn)
        } else {
            InicioSesion(usuario: $usuario, loggedIn: $loggedIn)
        }
    }
}
