//
//  Components.swift
//  App_RETO
//
//  Created by Marco Ramos Jalife on 31/08/25.
//

import SwiftUI
import Foundation

struct AppTheme {
    static let corner: CGFloat = 16
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
    static let bigSpacing: CGFloat = 16
}

extension Color {
    static var appPrimary: Color {
        if let ui = UIColor(named: "AppPrimary") { return Color(ui) }
        return Color.blue
    }
    static var appAccent: Color {
        if let ui = UIColor(named: "AppAccent") { return Color(ui) }
        return Color.orange
    }
    static var appSecondary: Color {
        if let ui = UIColor(named: "AppSecondary") { return Color(ui) }
        return Color.gray
    }
    static var appBackground: Color {
        if let ui = UIColor(named: "AppBackground") { return Color(ui) }
        return Color(UIColor.systemBackground)
    }
    static var appCard: Color {
        if let ui = UIColor(named: "AppCard") { return Color(ui) }
        return Color(UIColor.secondarySystemBackground)
    }
}

extension View {
    func cardStyle() -> some View {
        self.padding(AppTheme.padding)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
    }
    func primaryText() -> some View { self.font(.title3) }
    func largeControl() -> some View { self.controlSize(.large) }
    func primaryFill() -> some View { self.tint(.appPrimary) }
}

/* ----------------- Botones compatibles ----------------- */
struct AppFilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.white)
            .padding(.vertical, 12).padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(Color.appAccent.opacity(configuration.isPressed ? 0.85 : 1.0))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
struct AppOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.appPrimary)
            .padding(.vertical, 12).padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.corner)
                    .stroke(Color.appPrimary.opacity(configuration.isPressed ? 0.7 : 1.0), lineWidth: 1.5)
            )
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
enum AppButtonKind { case filled, outline }
struct AppButtonStyleModifier: ViewModifier {
    let kind: AppButtonKind
    func body(content: Content) -> some View {
        switch kind {
        case .filled:  content.buttonStyle(AppFilledButtonStyle())
        case .outline: content.buttonStyle(AppOutlineButtonStyle())
        }
    }
}
extension View {
    func appButtonStyle(_ kind: AppButtonKind) -> some View {
        self.modifier(AppButtonStyleModifier(kind: kind))
    }
}
struct AppButton: View {
    var title: String
    var fill: Bool = true
    var fullWidth: Bool = true
    var action: () -> Void
    var body: some View {
        Button(title, action: action)
            .font(.title3)
            .largeControl()
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .appButtonStyle(fill ? .filled : .outline)
    }
}

/* ----------------- Tarjetas y utilidades ----------------- */
struct PrimaryCard<Content: View>: View {
    var alignment: HorizontalAlignment = .leading
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: alignment, spacing: AppTheme.spacing, content: content)
            .cardStyle()
    }
}

/* StatCard con opción de “relleno” colorido (azul/naranja) */
struct StatCard: View {
    var icon: String
    var title: String
    var value: String
    var fillColor: Color? = nil   // nil = sutil (appCard), color = lleno con texto blanco

    var body: some View {
        if let fill = fillColor {
            let grad = LinearGradient(
                colors: [fill.opacity(0.95), fill.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 8) {
                Label(title, systemImage: icon).font(.headline)
                Text(value).font(.largeTitle).bold()
            }
            .foregroundStyle(Color.white)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(grad)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
        } else {
            PrimaryCard {
                Label(title, systemImage: icon).font(.headline)
                Text(value).font(.largeTitle).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LabeledValueRow: View {
    var label: String
    var value: String
    var body: some View {
        HStack { Text(label).foregroundStyle(.secondary); Spacer(); Text(value) }
            .primaryText()
    }
}

struct EmptyStateView: View {
    var icon: String
    var title: String
    var message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    var body: some View {
        VStack(spacing: AppTheme.bigSpacing) {
            Image(systemName: icon).font(.system(size: 56))
            VStack(spacing: 6) {
                Text(title).font(.title).bold()
                Text(message).multilineTextAlignment(.center).foregroundStyle(.secondary)
            }
            if let actionTitle, let action { AppButton(title: actionTitle, action: action) }
        }
        .padding(24)
    }
}

/* ----------------- Modelo + Estado global ----------------- */
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

    private func save() {
        if let data = try? JSONEncoder().encode(citas) {
            UserDefaults.standard.set(data, forKey: "citas")
        }
    }
    private static func load() -> [Cita] {
        guard let data = UserDefaults.standard.data(forKey: "citas"),
              let items = try? JSONDecoder().decode([Cita].self, from: data) else { return [] }
        return items
    }
}

/* ----------------- Tab bar: colores seleccionado / no seleccionado ----------------- */
struct TabBarConfigurator: UIViewControllerRepresentable {
    var selected: UIColor
    var unselected: UIColor
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.appBackground)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = selected
        UITabBar.appearance().unselectedItemTintColor = unselected
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
extension View {
    func tabBarColors(selected: Color, unselected: Color) -> some View {
        self.background(
            TabBarConfigurator(selected: UIColor(selected), unselected: UIColor(unselected))
        )
    }
}

struct AppTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding()
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .font(.title3)
    }
}

struct AppSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .padding()
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .font(.title3)
    }
}

