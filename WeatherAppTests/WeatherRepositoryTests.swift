//
//  WeatherRepositoryTests.swift
//  WeatherAppTests
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import XCTest
@testable import WeatherApp
import Moya
import RxBlocking

class WeatherRepositoryTests: XCTestCase {
    func testGetWeatherList() {
        let provider = MoyaProvider<WeatherAPI>(stubClosure: { _ in .immediate })
        let sut = WeatherRepository(provider: provider)
        do {
            let result = try sut.getWeatherList(query: "test")
                .toBlocking()
                .single()
            if case let .success(models) = result {
                XCTAssertEqual(models.count, 2)

                XCTAssertEqual(models.first?.dt, 1592280000)
                XCTAssertEqual(models.first?.temp?.day, 33)
                XCTAssertEqual(models.first?.pressure, 1007)
                XCTAssertEqual(models.first?.humidity, 59)
                XCTAssertEqual(models.first?.weather?.first?.description, "moderate rain")
                XCTAssertEqual(models.first?.weather?.count, 1)

                XCTAssertEqual(models.last?.dt, 1592712000)
                XCTAssertEqual(models.last?.temp?.day, 31.53)
                XCTAssertEqual(models.last?.pressure, 1009)
                XCTAssertEqual(models.last?.humidity, 62)
                XCTAssertEqual(models.last?.weather?.first?.description, "moderate rain")
                XCTAssertEqual(models.last?.weather?.count, 1)
            } else {
                XCTFail("request weather list failed")
            }
        } catch {
            XCTFail("request weather list failed")
        }
    }
}
