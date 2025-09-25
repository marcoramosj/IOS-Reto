import SwiftUI
import UIKit
import Charts

struct AppTheme {
    static let corner: CGFloat = 18
    static let padding: CGFloat = 20
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

struct BotonSalida: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack { Text(title).font(.system(size: 18, weight: .medium)) }
                .buttonStyle(.bordered) // solo borde
                .controlSize(.large)    // hace el botón más grande
                .tint(Color.marca)      // color del borde y relleno de la figura
                .clipShape(RoundedRectangle(cornerRadius: 12))
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

struct TurnosChartView: View {
    let turnos: [TurnoHora]
    let selectedDay: Date
    let accessibleHour: (startHour: Int, endHour: Int, count: Int)?
    
    // Formatea la fecha para el título
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDay)
    }
    
    // Ayuda a determinar si la barra actual es parte del rango de horas más accesible
    private func isAccessible(hour: Int) -> Bool {
        guard let range = accessibleHour else { return false }
        return hour >= range.startHour && hour <= range.endHour
    }
    
    var body: some View {
        VStack {
            Text("Turnos por hora (\(formattedDate))")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                Chart {
                    ForEach(groupedByHour, id: \.hour) { item in
                        BarMark(
                            x: .value("Hora", "\(item.hour):00"),
                            y: .value("Cantidad", item.count)
                        )
                        .foregroundStyle(isAccessible(hour: item.hour) ? Color.acento.gradient : Color.marca.gradient)
                    }
                    if let hourInfo = accessibleHour {
                        RuleMark(x: .value("Hora", "\(hourInfo.startHour):00"))
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundStyle(Color.acento)
                            .annotation(position: .overlay, alignment: .top, spacing: 10) {
                                Text("Más accesible")
                                    .font(.caption).bold()
                                    .foregroundStyle(Color.acento)
                                    .offset(y: -10)
                            }
                    }
                }
                .frame(width: 24 * 50, height: 200)
            }
            .padding()
        }
    }
}

struct EncabezadoUser: View {
    let usuario: String
    var body: some View {
        Text("Hola, \(usuario)")
            .font(.largeTitle.weight(.bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .accessibilityAddTraits(.isHeader)
    }
}

