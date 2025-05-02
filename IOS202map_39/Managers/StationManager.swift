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
        
        //現在位置の(経度・緯度)を代入
        let currentLati = currentLocation.latitude
        let currentLongi = currentLocation.longitude
        
        guard let stationAPIURL = URL(string: "https://express.heartrails.com/api/json?method=getStations&x=\(currentLongi)&y=\(currentLati)") else {
            print("URL取得失敗")
            return []
        }
        print("生成したURL: \(stationAPIURL)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: stationAPIURL)
            let json = try JSONDecoder().decode(StationResponse.self, from: data)
            let stations = json.response.station //StationModelを参照した配列を返す。
            print("取得した駅情報: \(stations)")
            return stations
        } catch {
            print("データ取得失敗: \(error.localizedDescription)")
        }
        return []
    }
}
