//
//  ContentView.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/28.
//

import SwiftUI
import MapKit
import Observation

struct ContentView: View {
    @State private var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            Map(position: $vm.locationManager.cameraPosition) {
                UserAnnotation()
                
                ForEach(vm.currentStations, id: \.id) { station in
                    Marker(station.name, coordinate: CLLocationCoordinate2D(latitude: station.y, longitude: station.x))
                }
            }
            .mapStyle()
            
            
            Button(action: {
                Task {
                    await vm.loadStations()
                }
            }) {
                Text("最寄駅を表示")
            }
        }
    }
}

extension View {
    func mapStyle() -> some View {
        self
            .mapControls {
                MapUserLocationButton()
                MapPitchToggle()
                MapCompass()
                MapScaleView()
                    .mapControlVisibility(.hidden)
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
    }
}

#Preview {
    ContentView()
}
