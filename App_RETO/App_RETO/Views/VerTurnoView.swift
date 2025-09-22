import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @State private var subtitle = "Example name"

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ScrollView {
                    VStack(spacing: 18) {
                        TurnoProfileImage(size: 120).padding(.top, 16)

                        Text(subtitle).font(.title3).bold().foregroundStyle(.gray)
                        Text("Tu turno: \(usuario)").font(.largeTitle).fontWeight(.bold).foregroundStyle(.gray)

                        Text("02").font(.largeTitle).fontWeight(.heavy).monospacedDigit().foregroundStyle(.orange)

                        Text("Ventanilla:").font(.largeTitle).fontWeight(.bold).foregroundStyle(.gray)
                        Text("03").font(.largeTitle).fontWeight(.heavy).monospacedDigit().foregroundStyle(.orange)

                        Spacer(minLength: 8)

                        BotonPantallasSecundario(
                            title: "Salir",
                            pantalla: DashboardUserView(usuario: $usuario, loggedIn: $loggedIn),
                            color: .marca
                        )
                        .frame(maxWidth: .infinity, minHeight: 65)
                        .font(.title2)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    }
                    .padding(20)
                }
            }
            .background(Color.white)
            .navigationTitle("Ver turno")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navBarStyleGray()
    }
}

#Preview { VerTurnoView(usuario: .constant("Usuario"), loggedIn: .constant(true)) }
