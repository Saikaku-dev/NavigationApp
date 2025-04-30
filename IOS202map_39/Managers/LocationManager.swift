//
//  LocationManager.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/28.
//

import Observation
import MapKit
import SwiftUI

class LocationManager:NSObject,CLLocationManagerDelegate,ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    @Published var currentLocation:CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.currentLocation = location.coordinate
    }
}
