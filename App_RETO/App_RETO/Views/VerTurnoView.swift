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
                
                VStack(spacing: 18) {
                    TurnoProfileImage(size: 120)
                        .padding(.top, 16)
                    
                    Text(subtitle)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.white)
                    
                    Text("Tu turno: \(usuario)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("02")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("Ventanilla: ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("03")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 35) {
                        BotonPantallasSecundario(
                            title: "Salir",
                            pantalla: DashboardUserView(usuario:$usuario , loggedIn: $loggedIn),
                            color: .ColorBoton
                        )
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ocupa toda la pantalla
                .background(
                    RoundedRectangle(cornerRadius: 0) // sin bordes redondeados
                        .fill(Color.pantallasColor)
                        .ignoresSafeArea()
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VerTurnoView(usuario:.constant(""), loggedIn: .constant(true))
}
