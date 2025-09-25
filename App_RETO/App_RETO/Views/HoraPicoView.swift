import SwiftUI
import Charts

// Vista que contiene la gráfica y la tarjeta de información
struct HoraPicoView: View {
    @State private var turnos: [TurnoHora] = turnoHoraMock
    @State private var selectedDay: Date = Date()
    @EnvironmentObject var router: Router

    
    // Propiedad calculada para encontrar la hora con menos turnos y que sea la más temprana
    private var accessibleHourRange: (startHour: Int, endHour: Int, count: Int)? {
        let groupedByHour = Dictionary(grouping: turnos.filter { $0.scheduledDate.isSameDay(as: selectedDay) }) {
            Calendar.current.component(.hour, from: $0.scheduledDate)
        }
        
        let allHours = 0..<24
        let completeData = allHours.map { hour -> (hour: Int, count: Int) in
            return (hour: hour, count: groupedByHour[hour]?.count ?? 0)
        }
        
        // Encuentra el conteo mínimo de turnos
        guard let minCount = completeData.min(by: { $0.count < $1.count })?.count else { return nil }
        
        var bestStartHour: Int?
        var bestEndHour: Int?
        var currentStartHour: Int?
        
        // Itera para encontrar la secuencia de horas consecutivas con el conteo mínimo
        for i in 0..<completeData.count {
            if completeData[i].count == minCount {
                if currentStartHour == nil {
                    currentStartHour = completeData[i].hour
                }
            } else {
                if let start = currentStartHour {
                    let end = completeData[i - 1].hour
                    if bestStartHour == nil || (end - start > (bestEndHour! - bestStartHour!)) {
                        bestStartHour = start
                        bestEndHour = end
                    }
                    currentStartHour = nil
                }
            }
        }
        
        // Maneja el caso en que la secuencia mínima continúa hasta el final del día
        if let start = currentStartHour {
            let end = completeData.last!.hour
            if bestStartHour == nil || (end - start > (bestEndHour! - bestStartHour!)) {
                bestStartHour = start
                bestEndHour = end
            }
        }
        
        if let start = bestStartHour, let end = bestEndHour {
            return (startHour: start, endHour: end, count: minCount)
        }
        
        return nil
    }

    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.spacing) {
                
                // Título de la vista
                Text("Horas Accesibles")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, AppTheme.padding)
                
                Spacer()
                
                // Gráfica de turnos por hora
                TurnosChartView(turnos: turnos, selectedDay: selectedDay, accessibleHour: accessibleHourRange)
                    .background(Color.tabGray)
                    .cornerRadius(AppTheme.corner)
                    .padding(.horizontal, AppTheme.padding)
                
                
                // Tarjeta de la hora más accesible
                if let hourInfo = accessibleHourRange {
                    StatCard(
                        icon: "clock.fill",
                        title: "Hora más accesible del día",
                        value: "\(hourInfo.startHour):00 - \(hourInfo.endHour + 1):00",
                        fill: Color.marca
                    )
                    .padding(.horizontal, AppTheme.padding)
                    
                    Spacer()
                    
                    BotonPrincipal(title: "Salir") {
                        router.selected = .dashboard
                        router.popToRoot(.dashboard)
                    }
                    .padding(EdgeInsets(top: 30, leading: 40, bottom: 54, trailing: 40))
                }
                
                Spacer()
            }
            .navigationTitle("Hora Pico")
            .navigationBarTitleDisplayMode(.inline)
            .navBarStyleGray()
        }
    }
}

struct HoraPicoView_Previews: PreviewProvider {
    static var previews: some View {
        HoraPicoView()
            .environmentObject(Router())
    }
}
