//
//  TurnoStats.swift
//  
//
//  Created by ediaz205  on 9/20/25.
//

import SwiftUI
import Charts

struct TurnoStats: View {
    
    // Get the turno from a the given user
    
    //  Get the full current date
    private var currentDate: Date {
        return Date()
    }
    
    // Get only the current hour
    private var currentHour: Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    // Get the current turno
    private var selectedTurno: Turno? {
        currentTurno(of: 7, in: turnoData)
    }
    
    // Get the turnos ahead
    private var turnosInFront: Int {
        guard let t = selectedTurno else { return 0 }
        return turnosAhead(of: t, in: turnoData)
    }
    
    // Get the estimated wait time in front of a given turno
    private var estimatedQueueTime: Double {
        guard let t = selectedTurno else { return 0 }
        return estimatedWaitTime(of: t, in: turnoData)
    }
    
    
    // estimatedWaitTime(of: selectedTurno, in: turnoData)
    
    
    
    private var orderedHours: [Int] {
            let now = Calendar.current.component(.hour, from: Date())  // e.g. 22
            return (0..<24).map { (now + $0) % 24 }                   // [22,23,0,1,...21]
        }
    
    
    // public var estimatedListedTime = estimatedWaitTime(of: 4, in: <#T##[Turno]#>)
    

    
    
    
       var body: some View {
           VStack {
               if (turnosInFront > 0){
                   Text("Turnos por Delante")
                   Text("\(turnosInFront)")
                   
                   Text("Tiempo de Espera para Turno")
                   Text("\(Int(estimatedQueueTime)) minutos")
               }
               
               
               

               

               
               // Text("Tiempo de Espera a las \(currentHour):00")
               
               // Text("Ventanillas Abiertas a las \(currentHour):00")
               
               // Text("Tiempo Restante para Turno")
               
               let counts = turnos24hrInterval(turnos: turnoData)

               Chart {
                   ForEach(Array(orderedHours.enumerated()), id: \.element) { index, hour in
                       BarMark(
                           x: .value("Hour", String(hour)),
                           y: .value("Value", counts[index])
                       )
                   }
               }
               .chartXAxis {
                   AxisMarks(values: orderedHours.map { String($0) })
               }
               .frame(height: 200)
               .padding()

               Text("Tiempo de Espera por Hora (Estimado)")
               Chart {
                           ForEach(orderedHours, id: \.self) { hour in
                               BarMark(
                                x: .value("Hour", String(hour)),
                                   y: .value("Value", Double.random(in: 0...10))
                               )
                           }
                       }
                       .chartXAxis {
                           AxisMarks(values: orderedHours.map { String($0) })
                       }
                       .frame(height: 200)
                       .padding()
                   }
           Spacer()
               }
           }

#Preview {
    TurnoStats()
}
