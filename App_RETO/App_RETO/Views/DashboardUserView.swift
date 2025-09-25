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
                        BotonPrincipal(title: "Pedir Turno") {
                            router.selected = .turno
                            router.popToRoot(.turno)
                        }
                        BotonPrincipal(title: "Ver Hora Pico") {
                            router.selected = .hora
                            router.popToRoot(.hora)
                        }
                        Button(action:
                                {activeAlert = .cancelar}) {
                            HStack { Text("Cancelar Turno").font(.system(size: 24, weight: .bold)) }
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                                .buttonStyle(.bordered) // solo borde
                                .controlSize(.large)    // hace el botón más grande
                                .tint(Color.marca)      // color del borde y relleno de la figura
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                        
                        HStack(){
                            Spacer()
                            Button(action: {
                                activeAlert = .salir
                            }) {
                                Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                    .font(.system(size: 32, weight: .bold)) // tamaño del ícono
                            }
                            .buttonStyle(.bordered) // solo borde
                            .controlSize(.large)    // hace el botón más grande
                            .tint(Color.marca)      // color del borde y relleno de la figura
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
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
