//
//  DIContainer.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

struct Dependencies {
    private init() {}
    private static var dependencies: [String: Any] = [:]

    static subscript<Dependency>(_ type: Dependency.Type) -> Dependency {
        get {
            let key = String(describing: type)
            guard let dependency = dependencies[key] as? Dependency else {
                fatalError("No service of type \(key) registered!")
            }
            return dependency
        }
        set {
            let key = String(describing: type)
            dependencies[key] = newValue
        }
    }
}

@propertyWrapper
struct Dependency<Service> {
    var wrappedValue: Service {
        get { Dependencies[Service.self] }
        set { Dependencies[Service.self] = newValue }
    }
}
