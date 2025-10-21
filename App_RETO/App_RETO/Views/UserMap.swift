//
//  UserMap.swift
//  App_RETO
//
//  Created by ediaz205  on 10/16/25.
//

import SwiftUI
import MapKit

struct UserMap: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var showMap = true
    
    @State private var selectedLocation: LocationsList?
    @State private var showingDestinationList = false
    @State private var locations: [LocationsList] = []
    
    private let destinoNombre = "Hospital Clínica Nova"

    
    @State private var camera = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
                           span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
    )
    
    private func abrirEnAppleMaps(destino: LocationsList) {
        let coord = CLLocationCoordinate2D(latitude: destino.latitude, longitude: destino.longitude)
        let placemark = MKPlacemark(coordinate: coord)
        let item = MKMapItem(placemark: placemark)
        item.name = destino.locationName
        
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    var body: some View {
            ZStack(alignment: .bottom) {
                if showMap {
                    Map(position: $camera) {
                        ForEach(locations) { loc in
                            Annotation(loc.locationName,
                                       coordinate: CLLocationCoordinate2D(latitude: loc.latitude,
                                                                          longitude: loc.longitude)) {
                                ZStack {
                                    Circle().fill(Color.acento.opacity(0.20)).frame(width: 44, height: 44)
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(Color.acento)
                                        .shadow(radius: 3)
                                }
                            }
                        }
                    }
                    .mapStyle(.standard)
                    .ignoresSafeArea()
                } else {
                    Color.clear.ignoresSafeArea()
                }

                HStack {
                    Button {
                        showingDestinationList = true
                    } label: {
                        Label("Choose in Apple Maps", systemImage: "map.circle.fill")
                            .font(.headline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.marca)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .confirmationDialog("Select a destination", isPresented: $showingDestinationList) {
                        ForEach(locations) { loc in
                            Button(loc.locationName) {
                                selectedLocation = loc
                                abrirEnAppleMaps(destino: loc)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    locations = try await fetchLocationsList()
                    print("Locations loaded:", locations.count)
                } catch {
                    print("Error fetching data:", error)
                }
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    
                    DispatchQueue.main.async {
                        showMap = true
                    }
                case .inactive, .background:
                    showMap = false
                @unknown default:
                    break
                }
            }
        }
    }

#Preview {
    UserMap()
        .environmentObject(Router())
}
