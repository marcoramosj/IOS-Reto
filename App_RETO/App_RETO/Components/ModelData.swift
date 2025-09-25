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
    guard let url = URL(string: "los-cinco-informaticos.tc2007b.tec.mx:10206/turnos/ahead/\(IddeTurnos)") else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    let response = try decoder.decode(UsuarioTurnosAdelante.self, from: data)
    
    return response
}

struct BasedeDatos {
    static let emp1 = Usuario(nombre: "marcoramos", clave: "1234", id: "ID0001")
    static let emp2 = Usuario(nombre: "pedrosola", clave: "1234", id: "ID0035")
    static let emp3 = Usuario(nombre: "nachoperez", clave: "1234", id: "ID0801")
    static let info = [emp1, emp2, emp3]
    static var usuarioR = [["ID0001", 6, "RID0001"], ["ID0035", 3, "RID0035"], ["ID0801", 4, "RID0801"]]
}


struct TurnoHora: Identifiable {
    let id: Int
    let scheduledDate: Date
    let prescriptionId: String
    let comentario: String?
    let status: Int
}

let turnoHoraMock: [TurnoHora] = [
    TurnoHora(id: 1, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T08:15:00Z")!, prescriptionId: "RX2001", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 2, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T11:40:00Z")!, prescriptionId: "RX2002", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 3, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T09:25:00Z")!, prescriptionId: "RX2003", comentario: "Random time prescription", status: 0),
    TurnoHora(id: 4, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T14:50:00Z")!, prescriptionId: "RX2004", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 5, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T10:10:00Z")!, prescriptionId: "RX2005", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 6, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T16:30:00Z")!, prescriptionId: "RX2006", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 7, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T12:00:00Z")!, prescriptionId: "RX2007", comentario: nil, status: 1),
    TurnoHora(id: 8, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T08:55:00Z")!, prescriptionId: "RX2008", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 9, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T17:15:00Z")!, prescriptionId: "RX2009", comentario: nil, status: 0),
    TurnoHora(id: 10, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T13:45:00Z")!, prescriptionId: "RX2010", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 11, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T09:05:00Z")!, prescriptionId: "RX2011", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 12, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T18:20:00Z")!, prescriptionId: "RX2012", comentario: nil, status: 1),
    TurnoHora(id: 13, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T10:50:00Z")!, prescriptionId: "RX2013", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 14, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T15:35:00Z")!, prescriptionId: "RX2014", comentario: "Random time prescription", status: 1),
    TurnoHora(id: 15, scheduledDate: ISO8601DateFormatter().date(from: "2025-09-25T11:00:00Z")!, prescriptionId: "RX2015", comentario: "Random time prescription", status: 1)
]


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

extension TurnosChartView {
    var groupedByHour: [(hour: Int, count: Int)] {
        let filtered = turnos.filter { $0.scheduledDate.isSameDay(as: selectedDay) }
        let grouped = Dictionary(grouping: filtered) {
            Calendar.current.component(.hour, from: $0.scheduledDate)
        }
        
        let allHours = 0..<24
        let completeData = allHours.map { hour -> (hour: Int, count: Int) in
            return (hour: hour, count: grouped[hour]?.count ?? 0)
        }
        
        return completeData.sorted { $0.hour < $1.hour }
    }
}
