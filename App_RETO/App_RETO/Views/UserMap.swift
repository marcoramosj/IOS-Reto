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
    private let destinoCoordenadas = CLLocationCoordinate2D(
        latitude: 25.7320776,
        longitude: -100.3001734
    )

    @State private var camera = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.7320776, longitude: -100.3001734),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    private func abrirEnAppleMaps() {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: destinoCoordenadas))
        item.name = destinoNombre
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    var body: some View {
        Map(position: $camera) {
            Annotation(destinoNombre, coordinate: destinoCoordenadas) {
                ZStack {
                    Circle().fill(Color.acento.opacity(0.20))
                        .frame(width: 44, height: 44)
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.acento)
                        .shadow(radius: 3)
                }
            }
        }
        .mapStyle(.standard)
        .mapControls {
            MapCompass()
        }
        
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
    }

    private var bottomBar: some View {
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

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 5)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    UserMap().environmentObject(Router())
}
