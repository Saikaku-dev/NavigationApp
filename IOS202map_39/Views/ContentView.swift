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
            Map(position: $vm.cameraPosition) {
                UserAnnotation()
                
                ForEach(vm.currentStations, id: \.id) { station in
                    Annotation(
                        station.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: station.y,
                            longitude: station.x
                        )
                    ) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                .background(Color.white)
                                .clipShape(Circle())
                                .onTapGesture {
                                    vm.selectedStation = station
                                    vm.selectStation()
                                }
                        }
                    }
                }
                if let routePolyline = vm.routeManager.route?.polyline {
                    MapPolyline(routePolyline)
                        .stroke(.red, lineWidth: 4)
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
        .sheet(isPresented: $vm.showStationDeatil) {
            StationInfoView(vm: vm)
                .presentationDetents([.fraction(0.2)])
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
