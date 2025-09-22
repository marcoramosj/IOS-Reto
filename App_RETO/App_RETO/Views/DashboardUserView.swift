import SwiftUI

struct DashboardUserView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @State private var alerta = false

    var body: some View {
        NavigationStack {
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

                        // métricas
                        HStack(spacing: 20) {
                            StatPill(icon: "clock.badge.checkmark", title: "Próximo", value: "Hoy")
                            StatPill(icon: "number", title: "Número", value: "02")
                            StatPill(icon: "rectangle.3.group", title: "Ventanilla", value: "3")
                        }

                        // botones
                        VStack(spacing: 18) {
                            Button("Cancelar turno") { alerta = true }
                                .buttonStyle(PrimaryWideButtonStyle(fill: .marca))

                            NavigationLink {
                                TurnoView(usuario: $usuario, loggedIn: $loggedIn)
                            } label: {
                                Text("Pedir turno")
                            }
                            .buttonStyle(PrimaryWideButtonStyle(fill: .marca))
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
        }
        .navBarStyleGray()
    }
}

struct StatPill: View {
    var icon: String
    var title: String
    var value: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.acento)

            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8) // achica si no cabe

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.textPrimary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


struct PrimaryWideButtonStyle: ButtonStyle {
    var fill: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.bold))
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(fill)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

#Preview {
    DashboardUserView(usuario: .constant("marcoramos"), loggedIn: .constant(true))
}
