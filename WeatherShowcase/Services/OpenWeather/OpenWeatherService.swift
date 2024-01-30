//
//  OpenWeatherService.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

struct OpenWeatherService: WeatherService {
    enum Errors: Error {
        case couldNotCreateRequest
        case invalidResponse
    }
    
    @Dependency var networkService: any NetworkService
    
    private let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5")!
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func createRequest(endpoint: String, coordinate: Coordinate) throws -> URLRequest {let params: [String: String] = [
            "appid": apiKey,
            "units": "metric",
            "lat": String(coordinate.lat),
            "lon": String(coordinate.long)
        ]
        
        let url = baseUrl.appendingPathComponent(endpoint)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let finalUrl = urlComponents?.url else {
            throw Errors.couldNotCreateRequest
        }
        let request = URLRequest(url: finalUrl)
        return request
    }
    
    func fetchCurrentForecast(for coordinate: Coordinate) async throws -> WeatherForecast {
        let request = try createRequest(endpoint: "weather", coordinate: coordinate)
        let (data, response) = try await networkService.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw Errors.invalidResponse
        }
        
        let forecastResponse = try JSONDecoder.standard().decode(ForecastResponse.self, from: data)
        let weatherForecast = WeatherForecast(forecastResponse)
        return weatherForecast
    }
    
    func fetchFolowingForecasts(for coordinate: Coordinate) async throws -> [WeatherForecast] {
        let request = try createRequest(endpoint: "forecast", coordinate: coordinate)
        let (data, response) = try await networkService.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw Errors.invalidResponse
        }
        
        let multipleForecastsResponse = try JSONDecoder.standard().decode(MultipleForecastsResponse.self, from: data)
        let weatherForecasts = multipleForecastsResponse.list.map { WeatherForecast($0) }
        return weatherForecasts
    }
}
