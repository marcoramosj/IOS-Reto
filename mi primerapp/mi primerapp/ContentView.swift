import SwiftUI

struct PerfilEstudiantilApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum Carrera: String, CaseIterable, Identifiable {
    case Ingenieria = "Ingeniería"
    case Diseno = "Diseño"
    case Medicina = "Medicina"
    case Derecho = "Derecho"
    var id: String { rawValue }
}

struct ContentView: View {
    @State private var nombre: String = ""
    @State private var carrera: Carrera? = nil
    @State private var semestre: Int? = nil
    @State private var energia: Double = 50
    @State private var modoCrack: Bool = false
    @State private var modoChill: Bool = false
    @State private var suerte: Int? = nil
    @State private var mostrarPerfil: Bool = false
    @State private var mostrarError: Bool = false
    @State private var errorMensaje: String = ""
    @FocusState private var focoNombre: Bool

    var cuerpoImagen: some View {
        Image(imagenEnergia)
            .resizable()
            .scaledToFit()
            .frame(height: 140)
            .padding(.top, 8)
    }

    var imagenEnergia: String {
        let v = Int(energia)
        if v < 30 { return "image1" }
        if v <= 69 { return "image2" }
        if v <= 89 { return "image3" }
        return "image4" }

    var tituloEnergia: String {
        let v = Int(energia)
        if v < 30 { return "Baja" }
        if v <= 69 { return "Media" }
        if v <= 89 { return "Alta" }
        return "Over 9000" }

    var body: some View {
        ZStack {
            Color(red: 10/255, green: 28/255, blue: 80/255).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Perfil Estudiantil")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nombre del estudiante")
                            .foregroundStyle(.white.opacity(0.9))
                        TextField("Escribe tu nombre", text: $nombre)
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                            .padding(12)
                            .background(.white.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)
                            .focused($focoNombre)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Carrera universitaria")
                            .foregroundStyle(.white.opacity(0.9))
                        Picker("Carrera", selection: $carrera) {
                            Text("Selecciona…").tag(Carrera?.none)
                            ForEach(Carrera.allCases) { c in
                                Text(c.rawValue).tag(Carrera?.some(c))
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Semestre actual")
                            .foregroundStyle(.white.opacity(0.9))
                        Picker("Semestre", selection: $semestre) {
                            Text("Selecciona…").tag(Int?.none)
                            ForEach(1...12, id: \.self) { s in
                                Text("\(s)").tag(Int?.some(s))
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Energía: \(Int(energia))% · \(tituloEnergia)")
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        Slider(value: $energia, in: 0...100)
                        cuerpoImagen
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("🔥 Modo Crack", isOn: $modoCrack)
                            .tint(.orange)
                            .foregroundStyle(.white)
                        Toggle("😎 Modo Chill", isOn: $modoChill)
                            .tint(.cyan)
                            .foregroundStyle(.white)
                    }

                    HStack(spacing: 12) {
                        Button("Calcular suerte") {
                            focoNombre = false
                            suerte = Int.random(in: 1...100)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.mint)

                        Button("Mostrar perfil") {
                            focoNombre = false
                            if nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                errorMensaje = "Debes ingresar el nombre del alumno."
                                mostrarError = true
                                return
                            }
                            if carrera == nil {
                                errorMensaje = "Debes seleccionar una carrera."
                                mostrarError = true
                                return
                            }
                            if semestre == nil { semestre = 1 }
                            mostrarPerfil = true
                        }
                        .buttonStyle(.bordered)
                        .tint(.white)
                    }

                    if let suerte, mostrarPerfil {
                        perfilView(suerte: suerte)
                    } else if mostrarPerfil {
                        perfilView(suerte: nil)
                    }

                    Spacer(minLength: 24)
                }
                .padding(20)
            }
        }
        .alert("Error", isPresented: $mostrarError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMensaje)
        }
    }

    @ViewBuilder
    func perfilView(suerte: Int?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tu suerte en el próximo examen es \(suerte ?? 0)% 🍀")
                .font(.headline)
                .foregroundStyle(.white)
            HStack(alignment: .center, spacing: 16) {
                Image(imagenEnergia)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Nombre: \(nombre)")
                    Text("Carrera: \(carrera?.rawValue ?? "-")")
                    Text("Semestre: \(semestre ?? 1)")
                    Text("Energía: \(Int(energia))% — \(tituloEnergia)")
                    Text("Poderes: \(modoCrack ? "🔥 Crack" : "")\(modoCrack && modoChill ? " · " : "")\(modoChill ? "😎 Chill" : (!modoCrack ? "Ninguno" : ""))")
                }
                .foregroundStyle(.white)
            }
            .padding(16)
            .background(.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    ContentView()
}
