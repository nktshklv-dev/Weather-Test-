//
//  CurrentWeatherData.swift
//  Weather (Test)
//
//  Created by Nikita  on 10/8/22.
//

import Foundation


struct CurrentWeatherData: Codable{
    var weather: [Weather]
    var main: Main
    var name: String
}


struct Weather: Codable{
    var id: Int
    var description: String
    var icon: String
}

struct Main: Codable{
    var temp: Double
    var feels_like: Double
    var pressure: Double
    var humidity: Int
}

