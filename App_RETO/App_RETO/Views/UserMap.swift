//
//  UserMap.swift
//  App_RETO
//
//  Created by ediaz205  on 10/16/25.
//

import SwiftUI
import MapKit

struct UserMap: View {
    private let destinoNombre = "Hospital Clínica Nova"
    private let destinoCoordenadas = CLLocationCoordinate2D(latitude: 25.7320776,
                                                            longitude: -100.3001734)

    @State private var camera = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.7320776, longitude: -100.3001734),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    // MARK: - Open Apple Maps with directions
    private func abrirEnAppleMaps() {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: destinoCoordenadas))
        item.name = destinoNombre
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // MAP
            Map(position: $camera) {
                // Pin / annotation
                Annotation(destinoNombre, coordinate: destinoCoordenadas) {
                    ZStack {
                        Circle().fill(Color.acento.opacity(0.20)).frame(width: 44, height: 44)
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color.acento)
                            .shadow(radius: 3)
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea()

            HStack {
                Button(action: { abrirEnAppleMaps() }) {
                    Label("Open in Apple Maps", systemImage: "map.circle.fill")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.marca)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserMap()
        .environmentObject(Router())
}
