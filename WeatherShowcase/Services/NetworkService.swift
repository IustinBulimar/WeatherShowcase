//
//  NetworkService.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

protocol NetworkService {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkService {}
