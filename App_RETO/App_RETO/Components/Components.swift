//
//  Components.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 31/08/25.
//

import SwiftUI
import UIKit
import Foundation

struct AppTheme {
    static let corner: CGFloat = 18
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
}

extension Color {
    static var appPrimary: Color { Color(UIColor(named: "AppPrimary") ?? .systemBlue) }
    static var appAccent: Color { Color(UIColor(named: "AppAccent") ?? .systemOrange) }
    static var appBackground: Color { Color(UIColor(named: "AppBackground") ?? .systemBackground) }
    static var appCard: Color { Color(UIColor(named: "AppCard") ?? .secondarySystemBackground) }
    static var appPanel: Color { Color(UIColor(named: "AppPanel") ?? UIColor(red: 0.19, green: 0.24, blue: 0.28, alpha: 1)) }
}

struct AppButton: View {
    var title: String
    var fill: Bool = true
    var fullWidth: Bool = true
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.title3).bold().frame(maxWidth: fullWidth ? .infinity : nil).padding(.vertical, 12)
        }
        .foregroundColor(fill ? .white : .appPrimary)
        .background(fill ? Color.appAccent : Color.clear)
        .overlay(RoundedRectangle(cornerRadius: AppTheme.corner).stroke(Color.appPrimary, lineWidth: fill ? 0 : 1.5))
        .cornerRadius(AppTheme.corner)
    }
}

struct StatCard: View {
    var icon: String
    var title: String
    var value: String
    var fill: Color
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(fill.opacity(0.18)).frame(width: 38, height: 38)
                Image(systemName: icon).foregroundStyle(fill).font(.system(size: 17, weight: .semibold))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline)
                Text(value).font(.largeTitle).bold()
            }
            Spacer()
        }
        .padding(AppTheme.padding)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
    }
}

struct AppointmentCard: View {
    var title: String
    var subtitle: String
    var cancel: () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline).foregroundStyle(.white.opacity(0.9))
                Text(subtitle).foregroundStyle(.white.opacity(0.8))
            }
            Spacer()
            Button(action: cancel) {
                Text("Cancelar turno").font(.callout).bold().padding(.horizontal, 14).padding(.vertical, 8).foregroundStyle(.white)
            }
            .background(Color.appAccent)
            .clipShape(Capsule())
        }
        .padding(AppTheme.padding)
        .background(RoundedRectangle(cornerRadius: AppTheme.corner).fill(Color.appPanel))
        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
    }
}

struct Cita: Identifiable, Codable, Hashable {
    let id: UUID
    let paciente: String
    let fecha: Date
    let especialidad: String
    let notas: String
    init(id: UUID = UUID(), paciente: String, fecha: Date, especialidad: String, notas: String) {
        self.id = id; self.paciente = paciente; self.fecha = fecha; self.especialidad = especialidad; self.notas = notas
    }
}

final class AppState: ObservableObject {
    @Published var citas: [Cita] = [] { didSet { save() } }
    @Published var selectedTab: Int = 0
    init() { citas = Self.load() }
    func agregar(_ cita: Cita) { citas.append(cita) }
    func proxima() -> Cita? { citas.sorted { $0.fecha < $1.fecha }.first }
    func cancelarProxima() {
        guard let p = proxima(), let idx = citas.firstIndex(of: p) else { return }
        citas.remove(at: idx)
    }
    private func save() {
        if let data = try? JSONEncoder().encode(citas) { UserDefaults.standard.set(data, forKey: "citas") }
    }
    private static func load() -> [Cita] {
        guard let data = UserDefaults.standard.data(forKey: "citas"),
              let items = try? JSONDecoder().decode([Cita].self, from: data) else { return [] }
        return items
    }
}

struct TabBarConfigurator: UIViewControllerRepresentable {
    var selected: UIColor
    var unselected: UIColor
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let a = UITabBarAppearance()
        a.configureWithOpaqueBackground()
        a.backgroundColor = UIColor(Color.appBackground)
        UITabBar.appearance().standardAppearance = a
        UITabBar.appearance().scrollEdgeAppearance = a
        UITabBar.appearance().tintColor = selected
        UITabBar.appearance().unselectedItemTintColor = unselected
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension View {
    func tabBarColors(selected: Color, unselected: Color) -> some View {
        background(TabBarConfigurator(selected: UIColor(selected), unselected: UIColor(unselected)))
    }
}
