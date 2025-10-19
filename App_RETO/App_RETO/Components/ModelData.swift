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


func cancelTurno(turnoescogido: Int) async throws -> CancelResponse {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/turnos/\(turnoescogido)/cancel") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
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

struct Turn: Codable {
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

// MARK: - Función para traer las ubicaciones desde la API
//func fetchLocationsList() async throws -> [LocationsList] {
//    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/locations") else {
//        throw URLError(.badURL)
//    }
//    
//    let (data, _) = try await URLSession.shared.data(from: url)
//    let decoder = JSONDecoder()
//    return try decoder.decode([LocationsList].self, from: data)
//}

func fetchLocationsList() async throws -> [LocationsList] {
    guard let url = URL(string: "https://los-cinco-informaticos.tc2007b.tec.mx:10206/locations")
    else { throw URLError(.badURL) }

    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    return try decoder.decode([LocationsList].self, from: data)
}



// MARK: - UI Model
struct CallRecord: Identifiable, Equatable {
    let id: Int
    let name: String
    let date: String
    let duration: String
}

// MARK: - Types that match the server (note: PascalCase keys)
private struct CallAPIRow: Codable {
    let id: Int
    let name: String
    let number: String?
    let startedAt: Date
    let durationSec: Int?

    enum CodingKeys: String, CodingKey {
        case id          = "Id"
        case name        = "Name"
        case number      = "Number"
        case startedAt   = "StartedAt"
        case durationSec = "DurationSec"
    }
}

// MARK: - Reusable HTTP Error
struct HTTPError: LocalizedError {
    let status: Int
    let body: String
    var errorDescription: String? { "HTTP \(status): \(body)" }
}

// MARK: - JSON Encoder/Decoder
private func makeDecoder() -> JSONDecoder {
    let dec = JSONDecoder()

    // Accept both RFC-1123 (Swagger “Thu, 16 Oct 2025 00:44:00 GMT”) and ISO-8601
    let rfc1123 = DateFormatter()
    rfc1123.locale = Locale(identifier: "en_US_POSIX")
    rfc1123.timeZone = TimeZone(secondsFromGMT: 0)
    rfc1123.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"

    let iso = ISO8601DateFormatter()
    iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    dec.dateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let s = try container.decode(String.self)
        if let d = rfc1123.date(from: s) { return d }
        if let d = iso.date(from: s) { return d }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unrecognized date format: \(s)")
    }

    dec.keyDecodingStrategy = .useDefaultKeys
    return dec
}

private func makeEncoder() -> JSONEncoder {
    let enc = JSONEncoder()
    enc.dateEncodingStrategy = .iso8601
    return enc
}

// MARK: - Base URL
private let baseURL = "https://los-cinco-informaticos.tc2007b.tec.mx:10206"

// ============================================================
// MARK: - GET /users/{user_id}/calls  → list for one user
// ============================================================

private func fetchUserCalls(userId: Int) async throws -> [CallAPIRow] {
    guard let url = URL(string: "\(baseURL)/users/\(userId)/calls") else {
        throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let http = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    guard (200...299).contains(http.statusCode) else {
        let body = String(data: data, encoding: .utf8) ?? "<non-utf8 response>"
        throw HTTPError(status: http.statusCode, body: body)
    }

    return try makeDecoder().decode([CallAPIRow].self, from: data)
}

/// UI wrapper: maps API rows to view model (newest first)
func loadUserCallsForUI(userId: Int) async throws -> [CallRecord] {
    let rows = try await fetchUserCalls(userId: userId)
    let mapped = rows.map { row in
        CallRecord(
            id: row.id,
            name: row.name,
            date: {
                let df = DateFormatter()
                df.locale = Locale(identifier: "en_US_POSIX")
                df.dateFormat = "dd MMM yyyy, h:mm a"
                return df.string(from: row.startedAt)
            }(),
            duration: {
                guard let secs = row.durationSec else { return "" }
                let m = secs / 60, s = secs % 60
                return String(format: "%dm %02ds", m, s)
            }()
        )
    }
    // Sort by startedAt descending
    return mapped.sorted { lhs, rhs in
        // Parse back to date just for ordering (lightweight here).
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "dd MMM yyyy, h:mm a"
        return (df.date(from: lhs.date) ?? .distantPast) > (df.date(from: rhs.date) ?? .distantPast)
    }
}

// ============================================================
// MARK: - POST /calls  → create (leave as-is if you don’t need now)
// ============================================================

func createCall(name: String, number: String, startedAt: Date? = nil) async throws -> CallRecord {
    guard let url = URL(string: baseURL + "/calls") else { throw URLError(.badURL) }

    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")

    var body: [String: Any] = [
        "name": name,
        "number": number
    ]
    if let startedAt = startedAt {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        body["startedAt"] = iso.string(from: startedAt)
    }
    req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

    let (data, response) = try await URLSession.shared.data(for: req)
    guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
    guard (200...299).contains(http.statusCode) else {
        let text = String(data: data, encoding: .utf8) ?? "<non-utf8 response>"
        throw HTTPError(status: http.statusCode, body: text)
    }

    let row = try makeDecoder().decode(CallAPIRow.self, from: data)
    return CallRecord(
        id: row.id,
        name: row.name,
        date: {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "dd MMM yyyy, h:mm a"
            return df.string(from: row.startedAt)
        }(),
        duration: {
            guard let secs = row.durationSec else { return "" }
            let m = secs / 60, s = secs % 60
            return String(format: "%dm %02ds", m, s)
        }()
    )
}

// ============================================================
// MARK: - DELETE /users/{user_id}/calls/{call_id}
// ============================================================

func deleteUserCall(userId: Int, callId: Int) async throws {
    guard let url = URL(string: baseURL + "/users/\(userId)/calls/\(callId)") else {
        throw URLError(.badURL)
    }

    var req = URLRequest(url: url)
    req.httpMethod = "DELETE"

    let (data, response) = try await URLSession.shared.data(for: req)
    guard let http = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    guard (200...299).contains(http.statusCode) else {
        let body = String(data: data, encoding: .utf8) ?? "<non-utf8 response>"
        throw HTTPError(status: http.statusCode, body: body)
    }
}

/// UI wrapper
func deleteCallFromUI(userId: Int, call: CallRecord) async throws {
    try await deleteUserCall(userId: userId, callId: call.id)
}
