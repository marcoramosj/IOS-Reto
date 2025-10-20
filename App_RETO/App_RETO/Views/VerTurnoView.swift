import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @Binding var TurnoId: Int?
    @Binding var turnos: [Turn]
    
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
                        .font(.title).fontWeight(.bold).foregroundStyle(.gray)
                    

                    Text(TurnoId.map { "\($0)" } ?? "-")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.orange)

                    Text("Ventanilla:")
                        .font(.title).fontWeight(.bold).foregroundStyle(.gray)

                    Text("03")
                        .font(.system(size: 64, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.orange)

                    
                    

                   
                }
                .padding(AppTheme.padding)
            }
        }
        .background(Color.white)
        .navigationTitle("Ver turno")
        .navigationBarTitleDisplayMode(.inline)
        .navBarStyleGray()
    }
}

#Preview {
    VerTurnoView(usuario: .constant("Mario"), loggedIn:.constant(true), TurnoId: .constant(12),turnos: .constant([ Turn(IDTurno: 12),Turn(IDTurno: 13),Turn(IDTurno: 14)
                 ]) )
}
