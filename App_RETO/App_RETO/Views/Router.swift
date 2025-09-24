//
//  Router.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 23/09/25.
//

import SwiftUI

enum TabID: Hashable { case dashboard, turno, ver }

final class Router: ObservableObject {
    @Published var selected: TabID = .dashboard
    @Published var pathDashboard = NavigationPath()
    @Published var pathTurno = NavigationPath()
    @Published var pathVer = NavigationPath()

    func popToRoot(_ tab: TabID) {
        switch tab {
        case .dashboard: pathDashboard = NavigationPath()
        case .turno:     pathTurno = NavigationPath()
        case .ver:       pathVer = NavigationPath()
        }
    }
}
