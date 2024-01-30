//
//  WeatherService.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

protocol WeatherService {
    func fetchCurrentForecast(for coordinate: Coordinate) async throws -> WeatherForecast
    func fetchFolowingForecasts(for coordinate: Coordinate) async throws -> [WeatherForecast]
}


struct WeatherForecast: Identifiable {
    let id = UUID()
    let type: WeatherType?
    let day: Date?
    let temp: Double?
    let minTemp: Double?
    let maxTemp: Double?
}

enum WeatherType {
    case sunny
    case cloudy
    case rainy
    
    var description: String { String(describing: self) }
}
