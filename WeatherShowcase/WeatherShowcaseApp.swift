//
//  WeatherShowcaseApp.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import SwiftUI

@main
struct WeatherShowcaseApp: App {
    init() {
        insertDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            if isRunningTests {
                EmptyView()
            } else {
                WeatherView()
            }
        }
    }
    
    private func insertDependencies() {
        Dependencies[NetworkService.self] = URLSession.shared
        Dependencies[LocationService.self] = CoreLocationService()
        
        let openWeatherApiKey = environmentValue(for: "OPEN_WEATHER_API_KEY")
        Dependencies[WeatherService.self] = OpenWeatherService(apiKey: openWeatherApiKey)
    }
}
