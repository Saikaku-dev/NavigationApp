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
        ZStack(alignment: .bottomTrailing) {
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
                            Image(systemName: "tram.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                                .onTapGesture {
                                    vm.handleStationTap(station)
                                }
                        }
                    }
                }
                if vm.showRoute, let routePolyline = vm.routeManager.route?.polyline {
                    MapPolyline(routePolyline)
                        .stroke(.red, lineWidth: 4)
                }
            }
            .mapStyle()
            .onAppear {
                if let location = vm.locationManager.currentLocation {
                    vm.moveToCurrentLocation(location)
                }
            }
            
            Button(action: { //駅の一覧を表示する。
                vm.initialRoute()
                    Task {
                        await vm.loadStations()
                    }
                }) {
                    HStack {
                        Image(systemName: "tram.fill")
                            .font(.headline)
                        Text("周辺の駅")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .shadow(radius: 4)
                }
                .padding([.bottom, .trailing], 20)
        }
        .sheet(isPresented: $vm.showStationDeatil) {
            StationInfoView(vm: vm)
                .presentationDetents([.fraction(0.3)])
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
