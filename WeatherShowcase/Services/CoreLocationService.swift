//
//  CoreLocationService.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation
import Combine
import CoreLocation

class CoreLocationService: NSObject, CLLocationManagerDelegate, LocationService  {
    var currentCoordinate: AnyPublisher<Coordinate, Error>
    
    private let _currentCoordinate = CurrentValueSubject<Coordinate?, Error>(nil)
    private let locationManager = CLLocationManager()
    
    override init() {
        currentCoordinate = _currentCoordinate
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        handleAuthorization(status: locationManager.authorizationStatus)
    }
    
    private func handleAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorization(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clCoordinate = locations.first?.coordinate else { return }
        let newCoordinate = Coordinate(lat: clCoordinate.latitude, long: clCoordinate.longitude)
        _currentCoordinate.send(newCoordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _currentCoordinate.send(completion: .failure(error))
    }
    
}
