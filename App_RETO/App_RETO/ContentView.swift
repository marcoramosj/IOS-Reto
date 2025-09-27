//
//  ContentView.swift
//  App_RETO
//
//  Created by Alumno on 29/08/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    @State private var usuario = ""
    @State private var loggedIn = false
    @State private var idusuario = 0

    var body: some View {
        if loggedIn {
            UserTabs(usuario: $usuario, loggedIn: $loggedIn, idusuario: $idusuario)
        } else {
            InicioSesion(usuario: $usuario, loggedIn: $loggedIn, idusuario: $idusuario)
        }
    }
}
