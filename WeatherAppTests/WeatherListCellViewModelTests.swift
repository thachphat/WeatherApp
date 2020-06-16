//
//  WeatherListCellViewModelTests.swift
//  WeatherAppTests
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherListCellViewModelTests: XCTestCase {
    private let nilWeatherModel = WeatherModel(
        dt: nil,
        temp: nil,
        pressure: nil,
        humidity: nil,
        weather: nil)
    private let emptyWeatherModel = WeatherModel(
        dt: 1592280000,
        temp: .init(day: nil),
        pressure: 20,
        humidity: 25,
        weather: [])
    private let weatherModel = WeatherModel(
        dt: 1592280000,
        temp: .init(day: 44.4),
        pressure: 20,
        humidity: 25,
        weather: [.init(description: "weather desc 1"), .init(description: "weather desc 2")])

    func testNilWeatherInfo() {
        let sut = WeatherListCellViewModel(model: nilWeatherModel)
        XCTAssertEqual(sut.info, "")
    }

    func testEmptyWeatherInfo() {
        let date = Date(timeIntervalSince1970: 1592280000)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"

        let sut = WeatherListCellViewModel(model: emptyWeatherModel)
        XCTAssertEqual(sut.info,
"""
Date: \(formatter.string(from: date))

Pressure: 20

Humidity: 25
"""
        )
    }

    func testWeatherInfo() {
        let date = Date(timeIntervalSince1970: 1592280000)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"

        let sut = WeatherListCellViewModel(model: weatherModel)
        XCTAssertEqual(sut.info,
"""
Date: \(formatter.string(from: date))

Average Temperature: 44.4°C

Pressure: 20

Humidity: 25

Description: weather desc 1, weather desc 2
"""
        )
    }
}
