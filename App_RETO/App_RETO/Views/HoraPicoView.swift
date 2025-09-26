import SwiftUI
import Charts

struct HoraPicoView: View {
    @State private var turnos: [TurnoHora] = []   
    @State private var selectedDay: Date = Date()
    @EnvironmentObject var router: Router
    
    private var accessibleHourRange: (startHour: Int, endHour: Int, count: Int)? {
        let filtered = turnos.filter { $0.hourStart.isSameDay(as: selectedDay) }
        
        let grouped = filtered.reduce(into: [Int: Int]()) { dict, turno in
            let hour = Calendar.current.component(.hour, from: turno.hourStart)
            dict[hour, default: 0] += turno.turnosCount
        }
        
        let completeData = (0..<24).map { hour -> (hour: Int, count: Int) in
            (hour, grouped[hour] ?? 0)
        }
        
        guard let minCount = completeData.min(by: { $0.count < $1.count })?.count else { return nil }
        
        var bestStartHour: Int?
        var bestEndHour: Int?
        var currentStartHour: Int?
        
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
        VStack {
            NavigationView {
                VStack(spacing: AppTheme.spacing) {
                    
                    Text("Horas Accesibles")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, AppTheme.padding)
                    
                    Spacer()
                    
                    
                    TurnosChartView(
                        turnos: turnos,
                        selectedDay: selectedDay,
                        accessibleHour: accessibleHourRange
                    )
                    .background(Color.tabGray)
                    .cornerRadius(AppTheme.corner)
                    .padding(.horizontal, AppTheme.padding)
                    .frame(maxWidth: 700,maxHeight: 300)
                    
                    if let hourInfo = accessibleHourRange {
                        StatCard(
                            icon: "clock.fill",
                            title: "Hora más accesible del día",
                            value: "\(hourInfo.startHour):00 - \(hourInfo.endHour + 1):00",
                            fill: Color.marca
                        )
                        .padding(.horizontal, AppTheme.padding)
                        
                        Spacer()
                        
                        BotonPrincipal(title: "Regresar") {
                            router.selected = .dashboard
                            router.popToRoot(.dashboard)
                        }
                    }
                    
                    Spacer()
                }
                .padding(AppTheme.padding)
                .navigationTitle("Hora Pico")
                .navigationBarTitleDisplayMode(.inline)
                .navBarStyleGray()
            }
        }
        .task {
            do {
                turnos = try await fetchTurnosDia()
            } catch {
                print("Error cargando turnos:", error)
            }
        }
    }
}

struct HoraPicoView_Previews: PreviewProvider {
    static var previews: some View {
        HoraPicoView()
            .environmentObject(Router())
    }
}
