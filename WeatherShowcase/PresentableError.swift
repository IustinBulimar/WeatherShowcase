//
//  PresentableError.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation

enum PresentableError: LocalizedError {
    case generic
    
    var errorDescription: String? {
        switch self {
        case .generic:
            return "Something went wrong. Please try again later."
        }
    }
}
