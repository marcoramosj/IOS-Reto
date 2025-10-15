import SwiftUI
import MapKit

enum ActiveAlert: Identifiable {
    case cancelar, salir, mensaje
    var id: Int { hashValue }
}

struct DashboardUserView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @Binding var idusuario: Int
    
    @State private var activeAlert: ActiveAlert?
    @State private var turnos: [Turn] = []
    @State private var turno: UsuarioTurnosAdelante? = nil
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    @EnvironmentObject var router: Router
    private let destinoCoordenadas = CLLocationCoordinate2D(latitude: 25.7320776, longitude: -100.3001734)
    private let destinoNombre = "Hospital Clínica Nova"

    private func abrirEnAppleMaps() {
        let destino = MKMapItem(placemark: MKPlacemark(coordinate: destinoCoordenadas))
        destino.name = destinoNombre
        destino.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    var turnoId: Int? {
        turnos.first?.IDTurno
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 32) {
                EncabezadoUser(usuario: usuario).padding(.top, 48)
                
                VStack(spacing: 20) {
                    // Tarjeta principal
                    VStack(spacing: 16) {
                        Text("Tu turno")
                            .font(.title.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))
                        
                        Text(turnoId != nil ? "\(turnoId!)" : "-")
                            .font(.system(size: 70, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)
                        
                        Text("Faltan \(turno?.turnosAhead ?? 0) turnos por delante")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.white)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .background(
                        LinearGradient(
                            colors: [Color.acento, Color.acento.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
                    
                    // Botones
                    VStack(spacing: 18) {
                        BotonPrincipal(title: "Pedir Turno") {
                            router.selected = .turno
                            router.popToRoot(.turno)
                        }
                        .disabled(turnoId != nil)
                        BotonPrincipal(title: "Ver Hora Pico") {
                            router.selected = .hora
                            router.popToRoot(.hora)
                        }
                        Button(action: { activeAlert = .cancelar }) {
                            Text("Cancelar Turno")
                                .font(.system(size: 24, weight: .bold))
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.marca)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        HStack {
                            Spacer()
                            HStack {
                                // Map button on the left
                                Button(action: { abrirEnAppleMaps() }) {
                                    Image(systemName: "map.circle.fill")
                                        .font(.system(size: 32, weight: .bold))
                                        .accessibilityLabel("Cómo llegar")
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .tint(Color.marca)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Spacer()
                                
                                // Logout button on the right
                                Button(action: { activeAlert = .salir }) {
                                    Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                        .font(.system(size: 32, weight: .bold))
                                        .accessibilityLabel("Cerrar sesión")
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .tint(Color.marca)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .background(Color.white)
        }
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .cancelar:
                    return Alert(
                        title: Text("¿Seguro?"),
                        message: Text("¿Quieres cancelar tu turno?"),
                        primaryButton: .destructive(Text("Continuar")) {
                            Task {
                                do {
                                    if let id = turnoId {
                                        let response = try await cancelTurno(turnoescogido: id)
                                        successMessage = response.formatted
                                        
                                        // Pido de nuevo los turnos actualizados
                                        let nuevosTurnos = try await fetchUserTurns(userId: idusuario)
                                        let nuevoTurno: UsuarioTurnosAdelante? =
                                            if let primero = nuevosTurnos.first {
                                                try await fetchTurnosAdelante(IddeTurnos: primero.IDTurno)
                                            } else {
                                                nil
                                            }
                                        
                                        turnos = nuevosTurnos
                                        turno = nuevoTurno
                                        activeAlert = .mensaje
                                    } else {
                                        successMessage = "No se encontró un turno para cancelar."
                                        activeAlert = .mensaje
                                    }
                                } catch {
                                    errorMessage = "Error de conexión al servidor."
                                    activeAlert = .mensaje
                                    print("🔎 Nuevos turnos:", turnos)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                
            case .salir:
                return Alert(
                    title: Text("¿Seguro?"),
                    message: Text("¿Quieres cerrar tu sesión?"),
                    primaryButton: .destructive(Text("Continuar")) {
                        loggedIn = false
                        router.selected = .inicio
                        router.popToRoot(.inicio)
                    },
                    secondaryButton: .cancel()
                )
                
            case .mensaje:
                return Alert(
                    title: Text("Aviso"),
                    message: Text(successMessage ?? errorMessage ?? "Operación completada."),
                    dismissButton: .default(Text("OK")) {
                        successMessage = nil
                        errorMessage = nil
                    }
                )
            }
        }
        .navBarStyleGray()
        .task {
            do {
                turnos = try await fetchUserTurns(userId: idusuario)
            } catch {
                errorMessage = "No se pudieron obtener los turnos."
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    DashboardUserView(
        usuario: .constant("marcoramos"),
        loggedIn: .constant(true),
        idusuario: .constant(8)
    )
    .environmentObject(Router())
}
