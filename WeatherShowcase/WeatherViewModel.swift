//
//  WeatherViewModel.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var currentForecast: WeatherForecast?
    @Published var todayForecast: WeatherForecast?
    @Published var folowingDaysForecasts: [WeatherForecast] = []
    @Published var error: (any LocalizedError)?
    @Published var isUpdating: Bool = false
    
    @Dependency var locationService: any LocationService
    @Dependency var weatherService: any WeatherService
    
    private var cancellables = Set<AnyCancellable>()
    
    func startUpdates() {
        locationService.currentCoordinate
            .sink { completion in
                
            } receiveValue: { [weak self] coordinate in
                self?.updateForecasts(for: coordinate)
            }
            .store(in: &cancellables)
    }
    
    private func updateForecasts(for coordinate: Coordinate) {
        Task {
            do {
                isUpdating = true
                try await withThrowingDiscardingTaskGroup { group in
                    group.addTask { @MainActor [weak self] in
                        self?.currentForecast = try await self?.weatherService.fetchCurrentForecast(for: coordinate)
                    }
                    
                    group.addTask { @MainActor [weak self] in
                        let forecasts = try await self?.weatherService.fetchFolowingForecasts(for: coordinate) ?? []
                        let dailyForecasts = self?.groupPerDay(forecasts) ?? []
                        self?.todayForecast = dailyForecasts.first(where: { self?.isTodayForecast($0) ?? false })
                        self?.folowingDaysForecasts = dailyForecasts.filter({ !(self?.isTodayForecast($0) ?? true) })
                    }
                }
                isUpdating = false
            } catch {
                if self.error == nil {
                    self.error = PresentableError.generic
                }
                isUpdating = false
            }
        }
    }
    
    private func isTodayForecast(_ forecast: WeatherForecast) -> Bool {
        guard let day = forecast.day else { return false }
        return Calendar.current.isDate(day, inSameDayAs: .now)
    }
    
    private func groupPerDay(_ forecasts: [WeatherForecast]) -> [WeatherForecast] {
        var groupedForecasts: [Date: [WeatherForecast]] = [:]
        forecasts.forEach { forecast in
            guard let date = forecast.day else { return }
            let startOfDay = Calendar.current.startOfDay(for: date)
            groupedForecasts[startOfDay, default: []].append(forecast)
        }
        
        let dailyForecasts = groupedForecasts
            .map { date, forecasts in
                var weatherTypeCounts: [WeatherType: Int] = [:]
                forecasts.compactMap(\.type).forEach { weatherType in
                    weatherTypeCounts[weatherType, default: 0] += 1
                }
                
                let mainWeatherType = weatherTypeCounts.max(by: { $0.value < $1.value })?.key
                let averageTemp = forecasts.compactMap(\.temp).reduce(0, +) / Double(forecasts.count)
                let minTemp = forecasts.compactMap(\.minTemp).min()
                let maxTemp = forecasts.compactMap(\.maxTemp).max()
                
                let dayForecast = WeatherForecast(type: mainWeatherType, day: date, temp: averageTemp, minTemp: minTemp, maxTemp: maxTemp)
                return dayForecast
            }
            .sorted(using: KeyPathComparator(\.day, order: .forward))
        
        return dailyForecasts
    }
    
}
