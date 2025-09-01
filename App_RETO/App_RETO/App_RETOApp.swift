//
//  App_RETOApp.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//

import SwiftUI

@main
struct App_RETOApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
