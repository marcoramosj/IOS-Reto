//
//  Router.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 23/09/25.
//

import SwiftUI

enum TabID: Hashable { case dashboard, turno, ver, hora, inicio, Map, Call }

final class Router: ObservableObject {
    @Published var selected: TabID = .dashboard
    @Published var pathDashboard = NavigationPath()
    @Published var pathTurno = NavigationPath()
    @Published var pathVer = NavigationPath()
    @Published var pathHora = NavigationPath()
    @Published var pathInicio = NavigationPath()
    @Published var pathMap = NavigationPath()
    @Published var pathCall = NavigationPath()


    

    func popToRoot(_ tab: TabID) {
        switch tab {
        case .dashboard: pathDashboard = NavigationPath()
        case .turno:     pathTurno = NavigationPath()
        case .ver:       pathVer = NavigationPath()
        case .hora:      pathHora = NavigationPath()
        case .inicio:      pathInicio = NavigationPath()
        case .Map:      pathMap = NavigationPath()
        case .Call:      pathCall = NavigationPath()

        }
    }
}
