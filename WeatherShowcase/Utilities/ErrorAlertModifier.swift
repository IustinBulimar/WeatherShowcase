//
//  ErrorAlertModifier.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import Foundation
import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var error: LocalizedError?

    func body(content: Content) -> some View {
        content
            .alert(isPresented: Binding<Bool>(
                get: { self.error != nil },
                set: { if !$0 { self.error = nil } }
            )) {
                Alert(title: Text(error?.errorDescription ?? "Unknown error"))
            }
    }
}

extension View {
    func errorAlert(_ error: Binding<LocalizedError?>) -> some View {
        self.modifier(ErrorAlertModifier(error: error))
    }
}
