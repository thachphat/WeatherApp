//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Phat Chiem on 6/17/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {
    func testSearch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.searchFields.containing(.button, identifier:"Clear text").element.tap()
        app.searchFields.buttons["Clear text"].tap()
        
        let okButton = app.alerts.scrollViews.otherElements.buttons["OK"]
        okButton.tap()
    }
}
