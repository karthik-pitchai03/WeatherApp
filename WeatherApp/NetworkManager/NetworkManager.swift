//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Apple on 17/10/22.
//

import Foundation
import CoreLocation

class NetworkManager{
    func fetchCurrenCitytWeather(city: String, completion: @escaping (WeatherModel) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "https://api.weatherapi.com/v1/forecast.json?key=\(NetworkProperties.API_KEY)&q=\(formattedCity)&days=7&aqi=no&alerts=no"
        
        guard let url = URL(string: API_URL) else {
                 fatalError()
             }
             let urlRequest = URLRequest(url: url)
             URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                 guard let data = data else { return }
                 do {
                     let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(currentWeather)
                 } catch {
                     print(error)
                 }
                     
        }.resume()
    }
}
func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ()) {
    let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(NetworkProperties.API_KEY)"
    
    guard let url = URL(string: API_URL) else {
             fatalError()
         }
         let urlRequest = URLRequest(url: url)
         URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
             guard let data = data else { return }
             do {
                 let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(currentWeather)
             } catch {
                 print(error)
             }
                 
    }.resume()
}
