//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    struct Temperature: Decodable {
        let day: Double?
    }
    struct Weather: Decodable {
        let description: String?
    }

    let dt: Double?
    let temp: Temperature?
    let pressure: Double?
    let humidity: Double?
    let weather: [Weather]?
}
