import SwiftUI

enum ActiveAlert: Identifiable {
    case cancelar, salir, mensaje
    var id: Int { hashValue }
}

struct DashboardUserView: View {
    @Binding var usuario: String
    @Binding var loggedIn: Bool
    @Binding var idusuario: Int
    @Binding var TurnoId: Int?
    @Binding var turnos: [Turn]

    @State private var activeAlert: ActiveAlert?
    
    @State private var turno: UsuarioTurnosAdelante? = nil
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    @State private var showCancelarDialog = false
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()

            VStack(spacing: 32) {
                EncabezadoUser(usuario: usuario).padding(.top, 48)

                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        Text("Tu turno")
                            .font(.title.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))

                        Text(TurnoId.map { "\($0)" } ?? "-")
                            .font(.system(size: 70, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)

                        Text("Faltan \(turno?.turnosAhead ?? 0) turnos por delante")
                            .font(.title3.weight(.medium))
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

                    VStack(spacing: 18) {
                        BotonPrincipal(title: "Pedir Turno") {
                            router.selected = .turno
                            router.popToRoot(.turno)
                        }
                        .disabled(TurnoId != nil)

                        BotonPrincipal(title: "Ver Hora Pico") {
                            router.selected = .hora
                            router.popToRoot(.hora)
                        }

                        Button(action:{
                            if TurnoId == nil {
                            errorMessage = "No tienes un turno activo para cancelar."
                            activeAlert = .mensaje
                        } else {
                            activeAlert = .cancelar
                        } }) {
                            Text("Cancelar Turno")
                                .font(.system(size: 24, weight: .bold))
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.marca)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Botón de cerrar sesión
                        HStack {
                            Spacer()
                            Button(action: { activeAlert = .salir }) {
                                Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                    .font(.system(size: 32, weight: .bold))
                                    .accessibilityLabel("Cerrar sesión")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .tint(Color.marca)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .background(Color.white)
        }
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .cancelar:
                return Alert(
                    title: Text("¿Quieres cancelar tu turno?"),
                    message: Text("¿Por que desea cancelar?"),
                    primaryButton: .destructive(Text("Continuar")) {
                        Task {
                            showCancelarDialog = true
                        }
                    },
                    secondaryButton: .cancel()
                )

            case .salir:
                return Alert(
                    title: Text("¿Seguro?"),
                    message: Text("¿Quieres cerrar tu sesión?"),
                    primaryButton: .destructive(Text("Continuar")) {
                        loggedIn = false
                        router.selected = .inicio
                        router.popToRoot(.inicio)
                    },
                    secondaryButton: .cancel()
                )

            case .mensaje:
                return Alert(
                    title: Text("Aviso"),
                    message: Text(successMessage ?? errorMessage ?? "Operación completada."),
                    dismissButton: .default(Text("OK")) {
                        successMessage = nil
                        errorMessage = nil
                    }
                )
            }
        }
        .navBarStyleGray()
        .confirmationDialog("¿Por qué desea cancelar?",
                            isPresented: $showCancelarDialog,
                            titleVisibility: .visible) {
            if let cancelid = TurnoId {
                Button("Ya no necesito el medicamento") {
                    print("Intentando cancelar \(cancelid)")

                    Task {
                        do {
                            let response = try await cancelTurno(turnoescogido: cancelid, comentario: "Ya no necesito el medicamento")
                            print("✅ \(response.formatted)")
                            await MainActor.run {
                                            router.necesitaActualizarTurnos = true
                                            TurnoId = nil
                                        }
                        } catch {
                            print("❌ Error al cancelar: \(error)")
                        }
                    }
                }
                Button("Error al agendar el turno") {
                    Task {
                        do {
                            let response = try await cancelTurno(turnoescogido: cancelid, comentario: "Error al agendar el turno")
                            print("✅ \(response.formatted)")
                            await MainActor.run {
                                            router.necesitaActualizarTurnos = true
                                            TurnoId = nil
                                        }
                        } catch {
                            print("❌ Error al cancelar: \(error)")
                        }
                    }
                }
                Button("Motivos personales") {
                    Task {
                        do {
                            let response = try await cancelTurno(turnoescogido: cancelid, comentario: "Motivos personales")
                            print("✅ \(response.formatted)")
                            await MainActor.run {
                                            router.necesitaActualizarTurnos = true
                                            TurnoId = nil
                                        }
                        } catch {
                            print("❌ Error al cancelar: \(error)")
                        }
                    }
                }
                Button("Otro") {
                    Task {
                        do {
                            let response = try await cancelTurno(turnoescogido: cancelid, comentario: "Otro")
                            print("✅ \(response.formatted)")
                            await MainActor.run {
                                            router.necesitaActualizarTurnos = true
                                            TurnoId = nil
                                        }
                        } catch {
                            print("❌ Error al cancelar: \(error)")
                        }
                    }
                }
                
            } else {
                Button("No hay turno activo", role: .cancel) { }
            }

            Button("Cancelar", role: .cancel) { }
        }
    }
}
#Preview {
    DashboardUserView(
        usuario: .constant("marcoramos"),
        loggedIn: .constant(true),
        idusuario: .constant(8),
        TurnoId: .constant(12),
        turnos: .constant([
                    Turn(IDTurno: 12, VentanillaId: 01),
                    Turn(IDTurno: 13, VentanillaId: 02),
                    Turn(IDTurno: 14,VentanillaId: 03)])
    )
    .environmentObject(Router())
}
