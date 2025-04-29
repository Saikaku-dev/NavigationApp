//
//  File.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/29.
//

import MapKit
import Observation

@Observable
class RouteManager {
    var route: MKRoute?
    
    func calculateRoute(
        from: CLLocationCoordinate2D, to: CLLocationCoordinate2D,transportType: MKDirectionsTransportType
    ) async -> Int? {
        let sourcePlacemark = MKPlacemark(coordinate: from)
        let destinationPlacemark = MKPlacemark(coordinate: to)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = transportType
        let directions = MKDirections(request: request)
        
        switch transportType {
        case .walking, .automobile:
            do {
                let response = try await directions.calculate()
                let routes = response.routes
                self.route = routes.first
                if let expectedTime = routes.first?.expectedTravelTime {
                    let minutes = Int(expectedTime / 60)
                    return minutes
                }
            } catch {
                print("ルート計算エラー: \(error.localizedDescription)")
            }
            
        case .transit:
            do {
                let etaResponse = try await directions.calculateETA()
                let etaMinutes = Int(etaResponse.expectedTravelTime / 60)
                return etaMinutes
            } catch {
                print("ETA 計算エラー: \(error.localizedDescription)")
            }
            
        default:
            print("未対応の交通手段")
        }
        return nil
    }
}
