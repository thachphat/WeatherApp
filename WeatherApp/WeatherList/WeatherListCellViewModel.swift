//
//  WeatherListCellViewModel.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import Foundation

protocol WeatherListCellViewModelProtocol {
    var info: String { get }
}

struct WeatherListCellViewModel: WeatherListCellViewModelProtocol, Equatable {
    let info: String
    init(model: WeatherModel) {
        var strings: [String] = []

        if let dt = model.dt {
            let date = Date(timeIntervalSince1970: dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "E, dd MMM yyyy"
            strings.append("Date: \(formatter.string(from: date))")
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2

        if let temperature = numberFormatter.string(for: model.temp?.day),
            !temperature.isEmpty {
            strings.append("Average Temperature: \(temperature)°C")
        }

        if let pressure = numberFormatter.string(for: model.pressure),
            !pressure.isEmpty {
            strings.append("Pressure: \(pressure)")
        }

        if let humidity = numberFormatter.string(for: model.humidity),
            !humidity.isEmpty {
            strings.append("Humidity: \(humidity)")
        }

        if let weather = model.weather, !weather.isEmpty {
            strings.append("Description: \(weather.compactMap { $0.description }.joined(separator: ", "))")
        }

        self.info = strings.joined(separator: "\n\n")
    }
}
