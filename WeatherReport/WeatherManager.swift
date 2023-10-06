//
//  WeatherManager.swift
//  WeatherReport
//
//  Created by Anoop on 02/01/23.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let apiKey = "b96cc373cb3cf4c7e3ed49b465ee2e54"
    let weatherUrl =  "https://api.openweathermap.org/data/2.5/weather?appid=b96cc373cb3cf4c7e3ed49b465ee2e54&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let url = "\(weatherUrl)&q=\(cityName)"
        print(url)
        performRequest(with: url)
    }
    // Fucntin Overloading
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        // 1. create a url
        if let url  =  URL(string: urlString) {
            //2. create a url session
            let session = URLSession(configuration: .default)
            //3. give the session a data task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error)
                    return
                }
                if let safeData = data {
                    if let weather = parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        //                        print(dataString)
                    }
                }
            }
                task.resume()
        }
    }
        
        func parseJson(_ weatherData : Data) -> WeatherModel? {
            let json = JSONDecoder()
            do {
                let data = try json.decode(WeatherData.self, from: weatherData)
                let id = data.weather[0].id
                let temp = data.main.temp
                let name = data.name
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                return weather
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    }

