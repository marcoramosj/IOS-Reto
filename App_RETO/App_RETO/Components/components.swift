import SwiftUI
import UIKit
import Foundation

struct AppTheme {
    static let corner: CGFloat = 18
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
}

extension Color {
    static var marca: Color { Color(red: 1/255, green: 104/255, blue: 138/255) }
    static var acento: Color { Color(red: 255/255, green: 153/255, blue: 0/255) }
    static var panel: Color { Color(red: 102/255, green: 102/255, blue: 102/255) }
    static var tabGray: Color { Color(UIColor.systemGray5) }
    static var headerGray: Color { Color(UIColor.systemGray5) }
    static var textPrimary: Color { Color(UIColor.label) }
}

struct Usuario {
    var nombre: String
    var clave: String
    var id: String
}

struct BasedeDatos {
    static let emp1 = Usuario(nombre: "marcoramos", clave: "1234", id: "ID0001")
    static let emp2 = Usuario(nombre: "pedrosola", clave: "1234", id: "ID0035")
    static let emp3 = Usuario(nombre: "nachoperez", clave: "1234", id: "ID0801")
    static let info = [emp1, emp2, emp3]
    static var usuarioR = [["ID0001", 6, "RID0001"], ["ID0035", 3, "RID0035"], ["ID0801", 4, "RID0801"]]
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
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner))
    }
}

struct BotonPrincipal: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack { Text(title).font(.system(size: 24, weight: .bold)) }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 40)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.marca)
    }
}

struct BotonSecundario: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack { Text(title).font(.system(size: 18, weight: .medium)) }
                .padding(.horizontal, 10)
                .frame(maxWidth: 150, minHeight: 50)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct BotonPantallas<Destino: View>: View {
    var title: String
    var pantalla: Destino
    var color: Color
    var body: some View {
        NavigationLink(destination: pantalla) {
            HStack { Text(title).font(.system(size: 24, weight: .bold)) }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 40)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
    }
}

struct BotonPantallasSecundario<Destino: View>: View {
    var title: String
    var pantalla: Destino
    var color: Color
    var body: some View {
        NavigationLink(destination: pantalla) {
            HStack { Text(title).font(.system(size: 27, weight: .bold)) }
                .padding(.horizontal, 10)
                .frame(maxWidth: 150, minHeight: 50)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
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
            .clipShape(Capsule())
        }
        .padding(AppTheme.padding)
        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
    }
}

func sectionLabel(_ text: String) -> some View {
    Text(text.uppercased())
        .font(.subheadline).bold()
        .foregroundStyle(Color.panel)
        .frame(maxWidth: .infinity, alignment: .leading)
}

struct TurnoProfileImage: View {
    var size: CGFloat = 64
    var body: some View {
        ZStack {
            Circle().fill(.black)
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding(size * 0.22)
                .foregroundStyle(.orange)
        }
        .overlay(Circle().stroke(.orange, lineWidth: size * 0.06))
        .frame(width: size, height: size)
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
    var background: UIColor
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let a = UITabBarAppearance()
        a.configureWithOpaqueBackground()
        a.backgroundColor = background
        UITabBar.appearance().standardAppearance = a
        UITabBar.appearance().scrollEdgeAppearance = a
        UITabBar.appearance().tintColor = selected
        UITabBar.appearance().unselectedItemTintColor = unselected
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct NavBarConfigurator: UIViewControllerRepresentable {
    var background: UIColor
    var title: UIColor
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        let a = UINavigationBarAppearance()
        a.configureWithOpaqueBackground()
        a.backgroundColor = background
        a.titleTextAttributes = [.foregroundColor: title]
        a.largeTitleTextAttributes = [.foregroundColor: title]
        UINavigationBar.appearance().standardAppearance = a
        UINavigationBar.appearance().scrollEdgeAppearance = a
        UINavigationBar.appearance().tintColor = title
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension View {
    func tabBarStyleGray() -> some View {
        background(TabBarConfigurator(selected: UIColor(Color.marca), unselected: UIColor(Color.secondary), background: UIColor(Color.tabGray)))
    }
    func navBarStyleGray() -> some View {
        background(NavBarConfigurator(background: UIColor(Color.headerGray), title: UIColor(Color.textPrimary)))
    }
}
