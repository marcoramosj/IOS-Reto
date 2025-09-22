import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ScrollView {
                    VStack(spacing: 28) {
                        TurnoProfileImage(size: 140)
                            .padding(.top, 20)

                        Text("Tu turno: \(usuario)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)

                        Text("02")
                            .font(.system(size: 72, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.orange)

                        Text("Ventanilla:")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)

                        Text("03")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.orange)

                        Spacer(minLength: 16)

                        NavigationLink {
                            DashboardUserView(usuario: $usuario, loggedIn: $loggedIn)
                        } label: {
                            Text("Salir")
                                .font(.title2.weight(.bold))
                                .frame(maxWidth: .infinity, minHeight: 70)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.marca)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 40)
                        .padding(.bottom, 24)
                    }
                    .padding(24)
                }
            }
            .background(Color.white)
            .navigationTitle("Ver turno")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navBarStyleGray()
    }
}

#Preview {
    VerTurnoView(usuario: .constant("Usuario Demo"), loggedIn: .constant(true))
}
