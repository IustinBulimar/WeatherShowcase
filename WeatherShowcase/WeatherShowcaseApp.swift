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
        Dependencies[LocationService.self] = CoreLocationService()
        Dependencies[WeatherService.self] = WeatherServiceStub(shouldFail: false)
    }
}
