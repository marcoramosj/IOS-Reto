//
//  StatsData.swift
//
//  Created by ediaz205 on 9/20/25
//

import Foundation

// 1) Define a single formatter for your yyyy-MM-dd HH:mm:ss format
public let turnoDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss"
    f.locale = Locale(identifier: "en_US_POSIX")
    return f
}()

// 2) Create 40 sample Turno values
let turnoData: [Turno] = [
    Turno(id: 0, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 00:00:00")!,
          status: false,
          servicedDate: turnoDateFormatter.date(from: "2025-09-23 00:03:00")!),

    Turno(id: 1, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 00:05:00")!,
          status:  false,
          servicedDate: turnoDateFormatter.date(from: "2025-09-23 00:08:00")!),

    Turno(id: 2, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 00:00:00")!,
          status:  false,
          servicedDate: turnoDateFormatter.date(from: "2025-09-23 00:03:00")!),

    Turno(id: 3, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 00:10:00")!,
          status:  false,
          servicedDate: turnoDateFormatter.date(from: "2025-09-23 00:12:00")!),

    Turno(id: 4, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 00:10:00")!,
          status:  false,
          servicedDate: turnoDateFormatter.date(from: "2025-09-23 00:13:00")!),

    Turno(id: 5, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 00:13:00")!,
          status:  false,
          servicedDate: turnoDateFormatter.date(from: "2025-09-23 00:15:00")!),

    
    Turno(id: 6, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 01:00:00")!,
          status: true,
          servicedDate: Date.distantFuture),

    Turno(id: 7, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 01:05:00")!,
          status: true,
          servicedDate: Date.distantFuture),

    Turno(id: 8, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 01:00:00")!,
          status: true,
          servicedDate: Date.distantFuture),

    Turno(id: 9, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 01:10:00")!,
          status: true,
          servicedDate: Date.distantFuture),

    Turno(id: 10, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 01:10:00")!,
          status: true,
          servicedDate: Date.distantFuture),

    Turno(id: 11, scheduledDate: turnoDateFormatter.date(from: "2025-09-23 01:13:00")!,
          status: true,
          servicedDate: Date.distantFuture)
]

// Get the turno object of a given id
func currentTurno(of id: Int, in turnos: [Turno]) -> Turno? {
    return turnos.first { $0.id == id && $0.status }
}

// Count the turnos ahead of a given turno object
func turnosAhead(of turno: Turno, in turnos: [Turno]) -> Int {
    return turnos.filter { t in
        t.status &&
        (
            t.scheduledDate < turno.scheduledDate ||
            (t.scheduledDate == turno.scheduledDate && t.id < turno.id)
        )
    }.count
}


/// W(t) = N_ahead(t) / ( μ - λ )
/// μ = 60 / avgServiceTimeMinutes (people/hour)
/// λ = arrival rate (people/hour)

// Calculate the estimated wait time for a given turno
func estimatedWaitTime(of turno: Turno, in turnos: [Turno]) -> Double {
    // 1. People already in line
    let nAhead = turnosAhead(of: turno, in: turnos)
    guard nAhead > 0 else { return 0 }
    print("nAhead: ", nAhead)

    // 2. Filter all turnos in the same hour, before this one
    let calendar = Calendar.current
    let sameHourTurnos = turnos.filter { t in
        t.status &&
        t.scheduledDate < turno.scheduledDate &&
        calendar.isDate(t.scheduledDate, equalTo: turno.scheduledDate, toGranularity: .hour)
    }
    print("sameHourTurnos: ", sameHourTurnos)

    let lambda = Double(sameHourTurnos.count)
    print("aRate λ: ", lambda)

    // 4. Service rate μ (people/hour)
    
    // Get all the turnos from the last false value in status back to one hour so that the service times can be elaborated on previous data
    let oneHourAgo = turno.scheduledDate.addingTimeInterval(-3600)

    let lastHourTurnos = turnos.filter { t in
        t.status == false &&
        t.servicedDate < turno.scheduledDate &&
        t.servicedDate >= oneHourAgo
    }
    print("lastHourTurnos: ", lastHourTurnos)
    
    let serviceTimes = lastHourTurnos.map {
        $0.servicedDate.timeIntervalSince($0.scheduledDate) / 60.0 // minutes per person
    }
    guard !serviceTimes.isEmpty else { return 0 }
    let avgServiceMinutes = serviceTimes.reduce(0, +) / Double(serviceTimes.count)
    let mu = 60.0 / avgServiceMinutes   // people/hour
    print("sRate μ: ", mu)


    // 5. Stability check
    guard mu > lambda else { return .infinity } // unstable system

    // 6. Wait time formula
    let waitHours = Double(nAhead) / (mu - lambda)
    print("waitHours: ", waitHours)
    return waitHours * 60.0  // minutes
}

// Count the assigned turnos in the next 24 hours starting from the current hour till the last per hourly.
// Example: from 2025-09-23 08:00:00 to from 2025-09-21 07:00:00
// 08:00:00: 3 turnos, 09:00:00: 5 turnos, 10:00:00 4 turnos, etc.
func turnos24hrInterval(turnos: [Turno]) -> [Int] {
    let calendar = Calendar.current
    let now = Date()
    
    // Align to the top of the current hour
    guard let startHour = calendar.dateInterval(of: .hour, for: now)?.start else {
        return Array(repeating: 0, count: 24)
    }
    
    var counts = Array(repeating: 0, count: 24)
    
    for t in turnos where t.status {
        let diff = calendar.dateComponents([.hour], from: startHour, to: t.scheduledDate).hour ?? -1
        if diff >= 0 && diff < 24 {
            counts[diff] += 1
        }
    }
    
    print("counts: \(counts)")
    return counts
}








