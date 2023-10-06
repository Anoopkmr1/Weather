//
//  ViewController.swift
//  WeatherReport
//
//  Created by Anoop on 01/01/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
 
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        
        
    }


    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print("button pressed")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
    }
    
   
    @IBAction func locationPressed(_ sender: UIButton) {
           locationManager.requestLocation()
       }
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               locationManager.stopUpdatingLocation()
               let lat = location.coordinate.latitude
               let lon = location.coordinate.longitude
               weatherManager.fetchWeather(latitude: lat, longitute: lon)
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
       }
    
    
}

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLbl.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

