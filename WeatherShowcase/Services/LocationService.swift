//
//  LocationService.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation
import Combine

protocol LocationService {
    var currentCoordinate: AnyPublisher<Coordinate, Error> { get }
}

struct Coordinate {
    let lat: Double
    let long: Double
}
