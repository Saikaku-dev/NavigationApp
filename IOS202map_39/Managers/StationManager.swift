//
//  StationManager.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/28.
//
import Foundation
import Observation

@Observable
class StationManager {
    
    var locationManager:LocationManager = LocationManager.shared
    
    func fetchStations() async -> [StationModel] {
        guard let currentLocation = locationManager.currentLocation else {
            print("現在の位置取得失敗")
            return []
        }
        
        let currentLati = currentLocation.latitude
        let currentLongi = currentLocation.longitude
        
        guard let stationAPIURL = URL(string: "https://express.heartrails.com/api/json?method=getStations&x=\(currentLongi)&y=\(currentLati)") else {
            print("URL取得失敗")
            return []
        }
        print("生成的URL: \(stationAPIURL)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: stationAPIURL)
            let json = try JSONDecoder().decode(StationResponse.self, from: data)
            let stations = json.response.station
            print("取得した駅情報: \(stations)")
            return stations
        } catch {
            print("データ取得失敗: \(error.localizedDescription)")
        }
        return []
    }
}
