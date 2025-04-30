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
    var locationManager:LocationManager = LocationManager.shared
    var stationManager = StationManager()
    var routeManager = RouteManager()
    var currentStations:[StationModel] = []
    var selectedStation:StationModel?
    
    var showStationDeatil: Bool = false
    var walkingEstimatedTime: Int?
    var drivingEstimatedTime: Int?
    var transitEstimatedTime: Int?
    var hasSetInitialCameraPosition = false
    var showRoute:Bool = false
    
    var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.698838, longitude: 139.696902),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    init() {
        Task {
            for await location in locationManager.$currentLocation.values {
                if let loc = location, !hasSetInitialCameraPosition{
                    self.moveToCurrentLocation(loc)
                    hasSetInitialCameraPosition = true
                }
            }
        }
    }
    
    @MainActor  //「最寄駅ボタン」押した際に、周囲の駅を配列に入れ表示する。
    func loadStations() async {
        let stations = await stationManager.fetchStations()
        self.currentStations = stations
        resetNavi()
    }
    
//    func selectStation() {
//        if let station = selectedStation {
//            cameraPosition = .region(
//                MKCoordinateRegion(
//                    center: CLLocationCoordinate2D(
//                        latitude: station.y,
//                        longitude: station.x),
//                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                )
//            )
//            showStationDeatil = true
//        }
//    }
    
    func prepareForNewStationSelection(with station: StationModel) {
        // 设置新车站
        selectedStation = station
        
        // 重置导航状态（防止上一次的 route 残留）
        routeManager.route = nil
        showRoute = false
        walkingEstimatedTime = nil
        drivingEstimatedTime = nil
        transitEstimatedTime = nil

        // 显示详情
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: station.y, longitude: station.x),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
        showStationDeatil = true

        // 加载三种交通方式的预计时间
        walkToStation()
        driveToStation()
        transitToStation()
    }

    func handleStationTap(_ station: StationModel) {
        prepareForNewStationSelection(with: station)
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
    
    //ルートおよび推定時間を値をnilに、そして選択した駅シートを閉める。
    func resetNavi() {
        routeManager.route = nil
        walkingEstimatedTime = nil
        drivingEstimatedTime = nil
        transitEstimatedTime = nil
        showStationDeatil = false
        showRoute = false
        selectedStation = nil
    }
    
    func startNavigation() {
        showStationDeatil = false
        showRoute = true
    }
    
    func moveToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
}
