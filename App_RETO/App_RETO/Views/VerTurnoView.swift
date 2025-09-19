import SwiftUI

struct VerTurnoView: View {
    @State private var title = "Agenda un turno"
    @State private var subtitle = "Example name"
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    TurnoProfileImage(size: 44)
                }
                .overlay(Text(title).font(.title2).bold())
                .padding(.horizontal)
                .padding(.top, 6)
                
                ScrollView {
                    VStack(spacing: 18) {
                        TurnoProfileImage(size: 120)
                            .padding(.top, 16)
                        
                        Text(subtitle)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.gray)
                        
                        Text("Tu turno: \(usuario)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        
                        Text("02")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .monospacedDigit()
                            .foregroundStyle(.orange)
                        
                        Text("Ventanilla:")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        
                        Text("03")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .monospacedDigit()
                            .foregroundStyle(.orange)
                        
                        Spacer(minLength: 8)
                        
                        // Botón más grande
                        BotonPantallasSecundario(
                            title: "Salir",
                            pantalla: DashboardUserView(usuario: $usuario, loggedIn: $loggedIn),
                            color: .ColorBoton
                        )
                        .frame(maxWidth: .infinity, minHeight: 65) 
                        .font(.title2) // texto más grande
                        .padding(.horizontal, 40) // margen a los lados
                        .padding(.bottom, 20)     // espacio con la Tab Bar
                        
                    }
                    .padding(20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.white) // fondo blanco limpio
        }
    }
}

#Preview {
    VerTurnoView(usuario: .constant("Usuario Demo"), loggedIn: .constant(true))
}
