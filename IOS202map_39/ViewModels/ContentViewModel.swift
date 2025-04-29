//
//  ContentViewModel.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/28.
//
import Observation
import MapKit
import SwiftUI

@Observable
class ContentViewModel {
    var currentStations:[StationModel] = []
    
    var locationManager:LocationManager = LocationManager.shared
    var stationManager = StationManager()
    
    @MainActor
    func loadStations() async {
        let stations = await stationManager.fetchStations()
        self.currentStations = stations
        if let firstStation = stations.first {
            locationManager.cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: firstStation.y, longitude: firstStation.x),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }
}
