//
//  Utility.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

var isRunningTests: Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

func environmentValue(for key: String) -> String {
    guard let value = ProcessInfo.processInfo.environment[key] else {
        fatalError("Could not obtain \(key)")
    }
    return value
}

func fetchDataMock<Model: Decodable>(for modelType: Model.Type) -> Data {
    let fileName = "\(modelType)Mock"
    
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        fatalError("\(fileName).json could not be found")
    }
    
    do {
        let mockData = try Data(contentsOf: url)
        return mockData
    } catch {
        fatalError("Could not fetch content of \(url)")
    }
}

func fetchModelMock<Model: Decodable>(for modelType: Model.Type, decoder: JSONDecoder = .standard()) -> Model {
    let data = fetchDataMock(for: modelType)
    
    do {
        let model = try decoder.decode(modelType, from: data)
        return model
    } catch {
        fatalError("Could not decode \(modelType)")
    }
}

extension JSONDecoder {
    static func standard() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
