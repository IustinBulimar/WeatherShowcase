//
//  ForecastResponse.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

struct MultipleForecastsResponse: Decodable {
    let list: [ForecastResponse]
}

struct ForecastResponse: Decodable {
    let dt: TimeInterval
    let weather: [Weather]
    let main: Main
}

extension ForecastResponse {
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
    }
}

extension WeatherForecast {
    init(_ response: ForecastResponse) {
        let weatherType = response.weather.first?.main
        switch weatherType {
        case "Clear":
            type = .sunny
        case "Clouds":
            type = .cloudy
        case "Rain":
            type = .rainy
        default:
            type = nil
        }
        day = Date(timeIntervalSince1970: response.dt)
        temp = response.main.temp
        minTemp = response.main.tempMin
        maxTemp = response.main.tempMax
    }
}
