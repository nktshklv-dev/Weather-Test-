//
//  HourlyWeatherManager.swift
//  Weather (Test)
//
//  Created by Nikita  on 10/8/22.
//

import Foundation



protocol HourlyWeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: HourlyWeatherManager, weather: HourlyWeatherData)
    func didFailWithError(error: Error)
}

struct HourlyWeatherManager{
    var delegate: HourlyWeatherManagerDelegate?
    var defaultURL = "api.openweathermap.org/data/2.5/forecast/daily?cnt=7&appid=c2249643fbc743dff414b110230958ed&units=metric"
    
    func createURL(lat: Double, lon: Double){
        let newURL = defaultURL + "&lat=\(lat.description)&lon=\(lon.description)"
        print(newURL)
        guard let url = URL(string: newURL) else {
            print("WRONG URL")
            return
        }
        performRequest(with: url)
    }
    
    
    func performRequest(with url: URL){
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                delegate?.didFailWithError(error: error!)
                return

            }
            guard let safeData = data else {return}
            guard let currentWeather = parseJSON(safeData) else {return}
            delegate?.didUpdateWeather(self, weather: currentWeather)
        }
        
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> HourlyWeatherData?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(HourlyWeatherData.self, from: data)
            let cnt = decodedData.cnt
            let list = decodedData.list
            let weatherModel = HourlyWeatherData(list: list, cnt: cnt)
            return weatherModel
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
}
