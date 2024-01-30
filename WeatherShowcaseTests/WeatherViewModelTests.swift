//
//  WeatherViewModelTests.swift
//  WeatherShowcaseTests
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import XCTest
import Combine

@testable import WeatherShowcase

final class WeatherViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func testUpdatingForecastsSucceeds() {
        let viewModel = WeatherViewModel()
        viewModel.locationService = LocationServiceStub()
        viewModel.weatherService = WeatherServiceStub(shouldFail: false)
        
        let expectation = expectation(description: "Finish updating")
        
        viewModel.$isUpdating
            .dropFirst()
            .sink { isUpdating in
                if !isUpdating {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.startUpdates()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertNotNil(viewModel.currentForecast)
        XCTAssertNotNil(viewModel.todayForecast)
        XCTAssertEqual(viewModel.folowingDaysForecasts.count, 5)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testUpdatingForecastsFails() {
        let viewModel = WeatherViewModel()
        viewModel.locationService = LocationServiceStub()
        viewModel.weatherService = WeatherServiceStub(shouldFail: true)
        
        let expectation = expectation(description: "Finish updating")
        
        viewModel.$isUpdating
            .dropFirst()
            .sink { isUpdating in
                if !isUpdating {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.startUpdates()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertNil(viewModel.currentForecast)
        XCTAssertNil(viewModel.todayForecast)
        XCTAssertEqual(viewModel.folowingDaysForecasts.count, 0)
        XCTAssertNotNil(viewModel.error)
    }

}
