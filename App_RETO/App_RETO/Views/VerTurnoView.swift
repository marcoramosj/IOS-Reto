// ======================== SWIFTUI VIEW ========================
import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @Binding var TurnoId: Int?

    @StateObject private var service = TurnoService()
    @EnvironmentObject var router: Router

    // Decide cuál ventanilla usar (cámbialo o pásalo por @Binding)
    @State private var ventanillaAUsar: Int = 1

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
                        .font(.title).fontWeight(.bold).foregroundStyle(.gray)

                    Text(TurnoId.map { "\($0)" } ?? "-")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .monospacedDigit().foregroundStyle(.orange)

                    Text("Ventanilla:")
                        .font(.title).fontWeight(.bold).foregroundStyle(.gray)

                    Group {
                        if service.cargando {
                            ProgressView("Iniciando servicio…").padding()
                        } else if let vent = service.ventanillaAsignada {
                            Text("\(vent)")
                                .font(.system(size: 64, weight: .heavy, design: .rounded))
                                .monospacedDigit().foregroundStyle(.orange)
                        } else if let error = service.error {
                            VStack(spacing: 10) {
                                Text("—").font(.system(size: 64, weight: .heavy, design: .rounded)).foregroundStyle(.gray)
                                Text(error).font(.footnote).foregroundStyle(.red)
                                Button("Reintentar") { Task { await service.startService(ventanillaId: ventanillaAUsar) } }
                                    .buttonStyle(.borderedProminent)
                            }
                        } else {
                            Text("-").font(.system(size: 64, weight: .heavy, design: .rounded)).foregroundStyle(.gray)
                        }
                    }
                }
                .padding(24)
            }
        }
        .background(Color.white)
        .navigationTitle("Ver turno")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // dispara al entrar
            await service.startService(ventanillaId: ventanillaAUsar)
            // si el backend devuelve turn_id, refléjalo en tu binding
            if let t = service.lastTurnId { TurnoId = t }
        }
    }
}

#Preview {
    VerTurnoView(
        usuario: .constant("Mario"),
        loggedIn: .constant(true),
        TurnoId: .constant(327)
    )
    .environmentObject(Router())
}
