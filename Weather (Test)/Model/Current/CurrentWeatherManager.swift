//
//  CurrentWeatherManager.swift
//  Weather (Test)
//
//  Created by Nikita  on 10/8/22.
//

import Foundation

protocol CurrentWeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: CurrentWeatherManager, weather: CurrentWeatherData)
    func didFailWithError(error: Error)
}

struct CurrentWeatherManager{
    
    var delegate: CurrentWeatherManagerDelegate?
    let defaultURL = "https://api.openweathermap.org/data/2.5/weather?appid=c2249643fbc743dff414b110230958ed&units=metric"
    
    func createURL(lat: Double, lon: Double){
        let newURL = defaultURL + "&lat=\(lat.description)&lon=\(lon.description)"
        print(newURL)
        guard let url = URL(string: newURL) else {
            print("WRONG URL")
            return
        }
        performRequest(url: url)
    }
    
    func performRequest(url: URL){
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                delegate?.didFailWithError(error: error!)
                return

            }
            guard let safeData = data else {return}
            print(safeData)
            guard let currentWeather = parseJSON(safeData) else {return}
            delegate?.didUpdateWeather(self, weather: currentWeather)
        }
        
        task.resume()
    }
    
    
    func parseJSON(_ data: Data) -> CurrentWeatherData?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(CurrentWeatherData.self, from: data)
            let weather = decodedData.weather
            let main = decodedData.main
            let name = decodedData.name
            let weatherModel = CurrentWeatherData(weather: weather, main: main, name: name)
            return weatherModel
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
}
