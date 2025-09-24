import SwiftUI

struct DashboardUserView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @State private var alerta = false
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()

            VStack(spacing: 32) {
                EncabezadoUser(usuario: usuario)

                VStack(spacing: 20) {
                    // tarjeta principal
                    VStack(spacing: 16) {
                        Text("Tu turno")
                            .font(.title.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))

                        Text("02")
                            .font(.system(size: 70, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)

                        Text("Falta 1 turno para llegar al tuyo")
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
                            alerta = true
                        }

                        BotonPrincipal(title: "Pedir Turno") {
                            router.selected = .turno
                            router.popToRoot(.turno)
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $alerta) {
            Alert(
                title: Text("Seguro?"),
                message: Text("¿Quieres cancelar tu turno?"),
                primaryButton: .destructive(Text("Continuar")) {},
                secondaryButton: .cancel()
            )
        }
        .navBarStyleGray()
    }
}

#Preview {
    DashboardUserView(usuario: .constant("marcoramos"), loggedIn: .constant(true))
        .environmentObject(Router())
}
