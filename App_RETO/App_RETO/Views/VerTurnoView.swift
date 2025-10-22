import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @Binding var TurnoId: Int?

    // Datos que vienen del padre (UserTabs)
    let ventanillaAsignada: Int?
    let cargando: Bool
    let mensaje: String?
    let error: String?

    // Acción para volver a intentar (el padre hace el fetch)
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                VStack(spacing: 28) {
                    Image("LogoNova2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 215)
                        .padding(.top, 80)

                    Text("Tu turno:")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)

                    Text(TurnoId.map { "\($0)" } ?? "-")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.orange)

                    Text("Ventanilla:")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)

                    Group {
                        if cargando {
                            ProgressView("Iniciando servicio...")
                                .padding()
                        } else if let vent = ventanillaAsignada {
                            Text("\(vent)")
                                .font(.system(size: 64, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(.orange)
                        } else if let msg = mensaje {
                            VStack(spacing: 8) {
                                Text("—")
                                    .font(.system(size: 64, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.gray)
                                Text(msg)
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 24)
                            }
                        } else if let err = error {
                            VStack(spacing: 10) {
                                Text("—")
                                    .font(.system(size: 64, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.gray)
                                Text(err)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                Button("Reintentar") { onRetry() }
                                    .buttonStyle(.borderedProminent)
                            }
                        } else {
                            Text("—")
                                .font(.system(size: 64, weight: .heavy, design: .rounded))
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .padding(24)
            }
        }
        .background(Color.white)
        .navigationTitle("Ver turno")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VerTurnoView(
        usuario: .constant("Mario"),
        loggedIn: .constant(true),
        TurnoId: .constant(329),
        ventanillaAsignada: 1,
        cargando: false,
        mensaje: nil,
        error: nil,
        onRetry: {}
    )
}
