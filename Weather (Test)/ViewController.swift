//
//  ViewController.swift
//  Weather (Test)
//
//  Created by Nikita  on 10/8/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CurrentWeatherManagerDelegate, HourlyWeatherManagerDelegate{
  
    

    var currentWeatherManager = CurrentWeatherManager()
    var hourlyWeatherManager = HourlyWeatherManager()
    let locationManager = CLLocationManager()
    var location = CLLocation()
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherConditionsLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        currentWeatherManager.delegate = self
        hourlyWeatherManager.delegate = self
        collectionView.dataSource = self
        tableView.dataSource = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}
//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         return UICollectionViewCell()
    }
    
    
}
//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         return UITableViewCell()
    }
    
    
}

//MARK: - CurrentWeatherManagerDelegate, HourlyWeatherManagerDelegate methods
extension ViewController{
    func didUpdateWeather(_ weatherManager: CurrentWeatherManager, weather: CurrentWeatherData) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = Int(weather.main.temp).description + "℃"
            self.cityLabel.text = weather.name
            self.weatherConditionsLabel.text = weather.weather[0].description.capitalized
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    func didUpdateWeather(_ weatherManager: HourlyWeatherManager, weather: HourlyWeatherData) {
         
    }
}

//MARK: - CLLocationManagerDelegate methods
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        locationManager.stopUpdatingLocation()
        self.location = location
        hourlyWeatherManager.createURL(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        currentWeatherManager.createURL(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if status == .authorizedWhenInUse {
               locationManager.requestLocation()
           }
       }
    
    
}

