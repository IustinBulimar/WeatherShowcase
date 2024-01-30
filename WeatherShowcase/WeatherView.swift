//
//  WeatherView.swift
//  WeatherShowcase
//
//  Created by Iustin Bulimar on 30.01.2024.
//

import SwiftUI


struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        EmptyView()
            .onAppear {
                viewModel.startUpdates()
            }
    }
}

#Preview {
    WeatherView()
}
