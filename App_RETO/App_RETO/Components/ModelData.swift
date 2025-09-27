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




