//
//  StationModel.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/28.
//
import Foundation

struct StationModel:Decodable,Identifiable {
    let id = UUID()
    let name: String
    let line: String
    let x: Double
    let y: Double
    let distance:String
}

struct StationList:Decodable {
    let station:[StationModel]
}

struct StationResponse: Decodable {
    let response: StationList
}
