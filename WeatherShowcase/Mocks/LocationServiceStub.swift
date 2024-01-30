//
//  LocationServiceStub.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation
import Combine

struct LocationServiceStub: LocationService {
    var currentCoordinate: AnyPublisher<Coordinate, Error>
    
    init() {
        currentCoordinate = Just(Coordinate.coordinateMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
