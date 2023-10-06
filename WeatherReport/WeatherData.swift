//
//  WeatherModel.swift
//  WeatherReport
//
//  Created by Anoop on 02/01/23.
//

import Foundation

struct WeatherData: Decodable {
    var name:String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
