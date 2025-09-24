//
//  App_RETOApp.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 21/08/25.
//
import SwiftUI

@main
struct App_RETOApp: App {
    @StateObject private var router = Router()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}
