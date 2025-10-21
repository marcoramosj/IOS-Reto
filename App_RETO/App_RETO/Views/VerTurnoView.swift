import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @Binding var TurnoId: Int?
    @State private var ventanillaAsignada: Int?
    @State private var cargando = false
    @State private var error: String?
    @State private var mensaje: String?
    
    @EnvironmentObject var router: Router
    
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
                    
                    if cargando {
                        ProgressView("Iniciando servicio...")
                            .padding()
                    } else if let vent = ventanillaAsignada {
                        Text("\(vent)")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.orange)
                    } else {
                        Text("-")
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .foregroundStyle(.gray)
                    }
                    
                }
                .padding(AppTheme.padding)
            }
        }
        .background(Color.white)
        .navigationTitle("Ver turno")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
}
#Preview {
    VerTurnoView(usuario: .constant("Mario"), loggedIn: .constant(true), TurnoId: .constant(nil))
}
