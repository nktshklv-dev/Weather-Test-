//
//  HourlyWeatherData.swift
//  Weather (Test)
//
//  Created by Nikita  on 10/8/22.
//

import Foundation


struct HourlyWeatherData: Codable{
    var list: [List]
    var cnt: Int
}

struct List: Codable{
    var dt: Int
    var main: MainHourly
    var weather: WeatherHourly
    
}

struct MainHourly: Codable{
    var temp: Double
}

struct WeatherHourly: Codable{
    var id: Int
    var main: String
    var icon: String
}
