//
//  WeatherServiceStub.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

struct WeatherServiceStub: WeatherService {
    enum Errors: Error {
        case generic
    }
    
    var shouldFail: Bool
    
    func fetchCurrentForecast(for coordinate: Coordinate) async throws -> WeatherForecast {
        guard !shouldFail else { throw Errors.generic }
        
        return .todayForecastMock
    }
    
    func fetchFolowingForecasts(for coordinate: Coordinate) async throws -> [WeatherForecast] {
        guard !shouldFail else { throw Errors.generic }
        
        var mockForecasts = (1...40).map({ _ in WeatherForecast.randomForecastMock() })
        mockForecasts.append(.todayForecastMock)
        return mockForecasts
    }
}
