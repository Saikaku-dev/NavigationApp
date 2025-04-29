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
    var selectedStation:StationModel?
    var showStationDeatil: Bool = false
    var routeManager = RouteManager()
    var walkingEstimatedTime: Int?
    var drivingEstimatedTime: Int?
    var transitEstimatedTime: Int?
    
    var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.698838, longitude: 139.696902),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @MainActor
    func loadStations() async {
        let stations = await stationManager.fetchStations()
        self.currentStations = stations
        if routeManager.route != nil {
            routeManager.route = nil
            resetTime()
        }
    }
    
    func selectStation() {
        if let station = selectedStation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: station.y,
                        longitude: station.x),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
            if routeManager.route != nil {
                routeManager.route = nil
                resetTime()
            }
            showStationDeatil = true
        }
    }
    
    func walkToStation() {
        calculate(to: selectedStation, transportType: .walking) { time in
            self.walkingEstimatedTime = time
        }
    }
    
    func driveToStation() {
        calculate(to: selectedStation, transportType: .automobile) { time in
            self.drivingEstimatedTime = time
        }
    }
    
    func transitToStation() {
        calculate(to: selectedStation, transportType: .transit) { time in
            self.transitEstimatedTime = time
        }
    }
    
    private func calculate(to station: StationModel?, transportType: MKDirectionsTransportType, setTime: @escaping (Int?) -> Void) {
        guard let station = station,
              let location = locationManager.currentLocation else {
            print("データ取得失敗")
            return
        }
        
        Task {
            let time = await routeManager.calculateRoute(
                from: location,
                to: CLLocationCoordinate2D(latitude: station.y, longitude: station.x),
                transportType: transportType
            )
            setTime(time)
        }
    }
    
    func resetTime() {
        walkingEstimatedTime = nil
        drivingEstimatedTime = nil
        transitEstimatedTime = nil
    }
    
    func startNavigation() {
        showStationDeatil = false
    }
}
