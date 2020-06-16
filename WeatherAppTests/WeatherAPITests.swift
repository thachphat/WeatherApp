//
//  WeatherAPITests.swift
//  WeatherAppTests
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import XCTest
@testable import WeatherApp
import Moya

class WeatherAPITests: XCTestCase {
    func testListWeatherAPI() {
        let sut = WeatherAPI.list(.init(q: "test query"))
        XCTAssertEqual(sut.baseURL.absoluteString, "https://api.openweathermap.org")
        XCTAssertEqual(sut.path, "data/2.5/forecast/daily")
        XCTAssertEqual(sut.method, .get)

        if case let .requestParameters(params, encoding) = sut.task {
            XCTAssertEqual(params.count, 4)
            XCTAssertEqual(params["q"] as? String, "test query")
            XCTAssertEqual(params["cnt"] as? Int, 7)
            XCTAssertEqual(params["appid"] as? String, "60c6fbeb4b93ac653c492ba806fc346d")
            XCTAssertEqual(params["units"] as? String, "metric")
            XCTAssertTrue(encoding is URLEncoding)
        } else {
            XCTFail("wrong params")
        }
    }
}
