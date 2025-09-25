import SwiftUI

struct VerTurnoView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @EnvironmentObject var router: Router

    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                VStack(spacing: 28) {
                    TurnoProfileImage(size: 140).padding(.top, 20)

                    Text("Tu turno: \(usuario)")
                        .font(.title).fontWeight(.bold).foregroundStyle(.gray)

                    Text("02")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.orange)

                    Text("Ventanilla:")
                        .font(.title).fontWeight(.bold).foregroundStyle(.gray)

                    Text("03")
                        .font(.system(size: 64, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.orange)

                    Spacer(minLength: 2)

                    Button {
                        router.selected = .dashboard
                        router.popToRoot(.dashboard)
                    } label: {
                        Text("Salir")
                            .font(.title2.weight(.bold))
                            .frame(maxWidth: .infinity, minHeight: 70)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.marca)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 54, trailing: 40))

                   
                }
                .padding(24)
            }
        }
        .background(Color.white)
        .navigationTitle("Ver turno")
        .navigationBarTitleDisplayMode(.inline)
        .navBarStyleGray()
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var mockUser = "Jane Doe"
        @State private var mockLoggedIn = true
        @StateObject private var router = Router() // Assuming Router is an ObservableObject

        var body: some View {
            VerTurnoView(usuario: $mockUser, loggedIn: $mockLoggedIn)
        }
    }

    // You need to return the container to display the preview
    return PreviewContainer()
}
