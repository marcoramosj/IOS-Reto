//
//  ModelData.swift
//  App_RETO
//
//  Created by Mauricio on 25/09/25.
//

import SwiftUI
import Foundation
import Charts


extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}


struct Usuario {
    var nombre: String
    var clave: String
    var id: String
}

struct UsuarioTurnosAdelante: Codable {
    let turnoId: Int
    let turnosAhead: Int
    
    enum CodingKeys: String, CodingKey {
        case turnoId = "turno_id"
        case turnosAhead = "turnos_ahead"
    }
}


func fetchTurnosAdelante(IddeTurnos:Int) async throws -> UsuarioTurnosAdelante {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/turnos/ahead/\(IddeTurnos)") else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    let response = try decoder.decode(UsuarioTurnosAdelante.self, from: data)
    
    return response
}

struct Cita: Identifiable, Codable, Hashable {
    let id: UUID
    let paciente: String
    let fecha: Date
    let especialidad: String
    let notas: String
    init(id: UUID = UUID(), paciente: String, fecha: Date, especialidad: String, notas: String) {
        self.id = id; self.paciente = paciente; self.fecha = fecha; self.especialidad = especialidad; self.notas = notas
    }
}

final class AppState: ObservableObject {
    @Published var citas: [Cita] = [] { didSet { save() } }
    @Published var selectedTab: Int = 0
    init() { citas = Self.load() }
    func agregar(_ cita: Cita) { citas.append(cita) }
    func proxima() -> Cita? { citas.sorted { $0.fecha < $1.fecha }.first }
    func cancelarProxima() {
        guard let p = proxima(), let idx = citas.firstIndex(of: p) else { return }
        citas.remove(at: idx)
    }
    private func save() {
        if let data = try? JSONEncoder().encode(citas) { UserDefaults.standard.set(data, forKey: "citas") }
    }
    private static func load() -> [Cita] {
        guard let data = UserDefaults.standard.data(forKey: "citas"),
              let items = try? JSONDecoder().decode([Cita].self, from: data) else { return [] }
        return items
    }
}



struct TurnoHora: Codable, Identifiable {
    let id = UUID()
    let hourStart: Date
    let period: String
    let turnosCount: Int

    enum CodingKeys: String, CodingKey {
        case hourStart = "HourStart"
        case period = "Period"
        case turnosCount = "TurnosCount"
    }
}

let rfc1123Formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

func fetchTurnosDia() async throws -> [TurnoHora] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/stats/turnos/24h-comparison")
    else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(rfc1123Formatter)
    return try decoder.decode([TurnoHora].self, from: data)
}

struct AccesoUsuario: Codable, Identifiable {
    let id = UUID()
    let nombre: String
    let password: String
    let iduser :Int

    enum CodingKeys: String, CodingKey {
        case nombre = "Username"
        case password = "Password"
        case iduser = "Id"
    }
}


func fetchUsuarios() async throws -> [AccesoUsuario] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/user/access") else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw URLError(.badServerResponse)
    }
    
    let decoder = JSONDecoder()
    return try decoder.decode([AccesoUsuario].self, from: data)
}


struct CancelResponse: Codable {
    let mensaje: String
    
    enum CodingKeys: String, CodingKey {
        case mensaje = "message"
    }
}

extension CancelResponse {
    var formatted: String {
        "\(mensaje)"
    }
}

func cancelTurno(turnoescogido: Int, comentario: String) async throws -> CancelResponse {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/turnos/\(turnoescogido)/cancel") else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: String] = ["comentario": comentario]
    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    // 🔍 DEBUG: imprime toda la respuesta para inspección
    print("📡 CancelTurno → HTTP \(httpResponse.statusCode)")
    if let bodyText = String(data: data, encoding: .utf8) {
        print("🧾 Respuesta del servidor:\n\(bodyText)")
    }

    guard 200..<300 ~= httpResponse.statusCode else {
        // Si el backend manda un mensaje de error JSON, lo decodificamos
        if let apiError = try? JSONDecoder().decode(CancelResponse.self, from: data) {
            print("⚠️ Error del backend: \(apiError.mensaje)")
        }
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(CancelResponse.self, from: data)
}


struct CreateTurnoResponse: Codable {
    let newTurnoId: Int
    let mensaje: String

    enum CodingKeys: String, CodingKey {
        case newTurnoId = "NewTurnoId"
        case mensaje = "message"
    }
}

//// MARK: - For /locations
//struct LocationsList: Codable, Identifiable {
//    let id = UUID()
//    let latitude: String
//    let longitude: String
//    let locationName: String
//
//    enum CodingKeys: String, CodingKey{
//        case latitude = "latitude"
//        case longitude = "longitude"
//        case locationName = "location_name"
//    }
//}

struct LocationsList: Codable, Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let locationName: String
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case locationName = "location_name"
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let latStr = try c.decode(String.self, forKey: .latitude)
        let lonStr = try c.decode(String.self, forKey: .longitude)
        latitude = Double(latStr) ?? 0.0
        longitude = Double(lonStr) ?? 0.0
        locationName = try c.decode(String.self, forKey: .locationName)
    }
}





func createTurno(
    scheduledDate: String,
    prescriptionId: String,
    comentariosReceta: String,
    usrId: Int
) async throws -> CreateTurnoResponse {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/turnos") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
        "Scheduled_Date": scheduledDate,
        "Perscription_Id": prescriptionId,
        "Comentarios_Receta": comentariosReceta,
        "Usr_Id": usrId
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw URLError(.badServerResponse)
    }
    
    let decoder = JSONDecoder()
    return try decoder.decode(CreateTurnoResponse.self, from: data)
}

struct Turn: Codable,Equatable {
    let IDTurno: Int

    enum CodingKeys: String, CodingKey {
        case IDTurno = "Id"
    }
}

func fetchUserTurns(userId: Int) async throws -> [Turn] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/users/\(userId)/turns") else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let decoded = try JSONDecoder().decode([Turn].self, from: data)
    return decoded
}


func fetchLocationsList() async throws -> [LocationsList] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/locations") else {
       throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode([LocationsList].self, from: data)
}

struct HistorialUs: Codable, Identifiable {
    
    // Propiedades en Swift (camelCase)
    let id: Int
    let scheduledDate: Date
    let perscriptionId: String
    let comentariosReceta: String?
    let status: Bool
    let comentariosCancelacion: String?
    
    // Mapeo de las claves JSON (de tu API) a las propiedades de Swift
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case scheduledDate = "Scheduled_Date"
        case perscriptionId = "Perscription_Id"
        case comentariosReceta = "Comentarios_Receta"
        case status = "Status"
        case comentariosCancelacion = "Comentarios_Cancelacion"

    }
}

func fetchHistorialUsuario(usuarioId: Int) async throws -> [HistorialUs] {
    
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/api/historial/usuario/\(usuarioId)") else {
        throw URLError(.badURL)
    }


    let (data, response) = try await URLSession.shared.data(from: url)

   
    // Verifica código de estado
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    // Verifica si la respuesta parece HTML (error del servidor)
    if let text = String(data: data, encoding: .utf8), text.lowercased().contains("<html") {
        throw URLError(.cannotParseResponse)
    }

    // --- Configuración del decodificador JSON ---
    let decoder = JSONDecoder()

    // Intenta decodificar diferentes formatos de fecha
    let apiDateFormatter = DateFormatter()
    apiDateFormatter.locale = Locale(identifier: "en_US_POSIX")
    apiDateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    
    decoder.dateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        // Intenta varios formatos
        let formatters = [
            apiDateFormatter,
            {
                let f = DateFormatter()
                f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                f.locale = Locale(identifier: "en_US_POSIX")
                return f
            }(),
            {
                let f = ISO8601DateFormatter()
                return f
            }()
        ]
        
        for formatter in formatters {
            if let date = (formatter as? DateFormatter)?.date(from: dateString) {
                return date
            } else if let iso = formatter as? ISO8601DateFormatter, let date = iso.date(from: dateString) {
                return date
            }
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Formato de fecha no reconocido")
    }

    // --- Decodificación segura ---
    do {
        if let decodedArray = try? decoder.decode([HistorialUs].self, from: data) {
            return decodedArray
        } else if let single = try? decoder.decode(HistorialUs.self, from: data) {
            return [single]
        } else {
            throw URLError(.cannotParseResponse)
        }
    } catch {
        throw error
    }
}



//>>>>>>> Stashed changes


// MARK: - For /api/activities/{caller_id}
struct Activity: Codable, Identifiable {
    let id: Int
    let contactoId: Int
    let contactoNombreCompleto: String
    let fechaContacto: String
    let llamador: String
    let numeroLlamado: String
    let tipoContacto: String

    enum CodingKeys: String, CodingKey {
        case id = "Historial_Id"
        case contactoId = "Contacto_Id"
        case contactoNombreCompleto = "Contacto_NombreCompleto"
        case fechaContacto = "Fecha_Contacto"
        case llamador = "Llamador"
        case numeroLlamado = "Numero_Llamado"
        case tipoContacto = "Tipo_Contacto"
    }
}

// MARK: - For /api/contactos
struct ListaContactos: Codable, Identifiable {
    let id: Int
    let name: String
    let middleName: String?
    let lastName: String?
    let lastName1: String?
    let telefono: String
    let correo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case middleName = "Middle_Name"
        case lastName = "Last_Name"
        case lastName1 = "LastName1"
        case telefono = "Telefono"
        case correo = "Correo"
    }
}

// MARK: - For /api/historial-contacto
struct HistorialContactoRequest: Codable {
    let callerId: Int
    let contactoId: Int
    let tipoContacto: String

    enum CodingKeys: String, CodingKey {
        case callerId = "Caller_Id"
        case contactoId = "Contacto_Id"
        case tipoContacto = "Tipo_Contacto"
    }
}


// MARK: - Función para traer actividades por Caller_Id desde la API
func fetchActivities(for callerId: Int) async throws -> [Activity] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/api/activities/\(callerId)") else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode([Activity].self, from: data)
}

// MARK: - Función para traer los Contactos desde la API
func fetchListaContactos() async throws -> [ListaContactos] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/api/contactos") else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode([ListaContactos].self, from: data)
}


// MARK: - POST request to insert new contact history record
func postHistorialContacto(_ request: HistorialContactoRequest) async throws -> Bool {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/api/historial-contacto") else {
        throw URLError(.badURL)
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let encoder = JSONEncoder()
    urlRequest.httpBody = try encoder.encode(request)
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    // Optional: check status code (e.g., 200 or 201)
    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
        print("Contacto registrado correctamente.")
        return true
    } else {
        print("Error \(httpResponse.statusCode): \(String(data: data, encoding: .utf8) ?? "Unknown error")")
        return false
    }
}
