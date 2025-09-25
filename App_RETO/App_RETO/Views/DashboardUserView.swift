import SwiftUI

enum ActiveAlert: Identifiable {
    case cancelar, salir
    var id: Int {
        hashValue }
}

struct DashboardUserView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @State private var activeAlert: ActiveAlert?
    @EnvironmentObject var router: Router
    @State private var turno: UsuarioTurnosAdelante? = nil
        @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()

            VStack(spacing: 32) {
                EncabezadoUser(usuario: usuario).padding(.top, 48)

                VStack(spacing: 20) {
                    // tarjeta principal
                    VStack(spacing: 16) {
                        Text("Tu turno")
                            .font(.title.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))

                        Text("8")
                            .font(.system(size: 70, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)

                        Text("Faltan \(turno?.turnosAhead ?? 0) turnos por delante")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.white)

                        Text("Ventanilla asignada: 3")
                            .font(.title3.weight(.bold))
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

                    // botones
                    VStack(spacing: 18) {
                        BotonPrincipal(title: "Cancelar turno") {
                            activeAlert = .cancelar
                        }

                        BotonPrincipal(title: "Pedir Turno") {
                            router.selected = .turno
                            router.popToRoot(.turno)
                        }
                        BotonPrincipal(title: "Hora Pico") {
                            router.selected = .hora
                            router.popToRoot(.hora)
                        }.padding(.bottom, 7)
                        Button(action: {
                            activeAlert = .salir
                        }) {
                            Text("Cerrar sesión")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(10)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.marca)
                    }
                    Spacer()

                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .cancelar:
                return Alert(
                    title: Text("¿Seguro?"),
                    message: Text("¿Quieres cancelar tu turno?"),
                    primaryButton: .destructive(Text("Continuar")) {},
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
            }
        }
        .navBarStyleGray()
    }
}


#Preview {
    DashboardUserView(usuario: .constant("marcoramos"), loggedIn: .constant(true))
        .environmentObject(Router())
}
