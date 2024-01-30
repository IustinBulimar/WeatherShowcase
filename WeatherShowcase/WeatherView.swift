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
        Group {
            if let currentForecast = viewModel.currentForecast,
                let todayForecast = viewModel.todayForecast {
                ScrollView {
                    VStack {
                        ZStack {
                            image(for: currentForecast)
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                degreesView(currentForecast.temp)
                                    .font(.system(size: 60, weight: .medium))
                                
                                Text(currentForecast.type?.description.uppercased() ?? "N/A")
                                    .font(.system(size: 40))
                            }
                            .offset(y: -30)
                        }
                        
                        HStack {
                            temperatureView(label: "min", temperature: todayForecast.minTemp)
                            Spacer()
                            temperatureView(label: "Current", temperature: currentForecast.temp)
                            Spacer()
                            temperatureView(label: "max", temperature: todayForecast.maxTemp)
                        }
                        .padding(.horizontal)
                        
                        Color.white
                            .frame(height: 1)
                        
                        nextDaysView
                    }
                }
                .background(color(for: currentForecast))
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
            } else {
                ContentUnavailableView("Forecast unavailable", systemImage: "thermometer.medium.slash")
            }
        }
        .errorAlert($viewModel.error)
        .onAppear {
            viewModel.startUpdates()
        }
    }
    
    var nextDaysView: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.folowingDaysForecasts) { forecast in
                HStack {
                    Text(forecast.day?.formatted(.dateTime.weekday(.wide)) ?? "")
                        .frame(width: 100, alignment: .leading)
                    
                    Spacer()
                    
                    icon(for: forecast)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 20, alignment: .center)
                    
                    Spacer()
                    
                    degreesView(forecast.maxTemp)
                        .frame(width: 100, alignment: .trailing)
                }
            }
        }
        .padding()
    }
    
    func degreesView(_ temperature: Double?) -> Text {
        Text((temperature != nil) ? "\(Int(temperature!.rounded()))°" : "N/A")
    }
    
    func temperatureView(label: String, temperature: Double?) -> some View {
        VStack {
            degreesView(temperature)
            Text(label)
        }
    }
    
    func image(for forecast: WeatherForecast) -> Image {
        switch forecast.type {
        case .sunny:
            Image("forest_sunny")
        case .cloudy:
            Image("forest_cloudy")
        case .rainy:
            Image("forest_rainy")
        default:
            Image("forest_sunny")
        }
    }
    
    func icon(for forecast: WeatherForecast) -> Image {
        switch forecast.type {
        case .sunny:
            Image("clear")
        case .cloudy:
            Image("partlysunny")
        case .rainy:
            Image("rain")
        default:
            Image("clear")
        }
    }
    
    func color(for forecast: WeatherForecast) -> Color {
        switch forecast.type {
        case .sunny:
            Color.sunnyGreen
        case .cloudy:
            Color.cloudyBlue
        case .rainy:
            Color.rainyGrey
        default:
            Color.sunnyGreen
        }
    }
}

#Preview {
    WeatherView()
}
