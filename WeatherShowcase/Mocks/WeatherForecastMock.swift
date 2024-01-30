//
//  WeatherForecastMock.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

extension WeatherForecast {
    static func randomForecastMock(date: Date? = nil) -> WeatherForecast {
        WeatherForecast(type: [WeatherType.sunny, .cloudy, .rainy].randomElement(),
                        day: date ?? .now.advanced(by: TimeInterval(60 * 60 * 24 * Int.random(in: 0...5))),
                        temp: Double.random(in: 0..<5),
                        minTemp: Double.random(in: 5..<10),
                        maxTemp: Double.random(in: 10..<15))
    }
    
    static var todayForecastMock: WeatherForecast = randomForecastMock(date: .now)
}
