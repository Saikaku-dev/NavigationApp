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
    
    func fetchStations() async -> [StationModel]{
        guard let stationAPIURL = URL(string: "https://express.heartrails.com/api/json?method=getStations&x=135.0&y=35.0") else {
            print("URL取得失敗")
            return []
        }
        
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
