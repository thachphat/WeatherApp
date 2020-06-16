//
//  WeatherListViewModelTests.swift
//  WeatherAppTests
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import XCTest
@testable import WeatherApp
import RxTest
import RxSwift

class WeatherListViewModelTests: XCTestCase {
    private let boolValues = ["t": true, "f": false]
    private let stringValues = ["e": nil, "q": "test query"]

    private let errorValues = ["e": nil, "v": "Something went wrong"]

    private let weatherModel1 = WeatherModel(dt: 1592280000, temp: .init(day: 33), pressure: 1007, humidity: 59, weather: [.init(description: "moderate rain")])
    private let weatherModel2 = WeatherModel(dt: 1592712000, temp: .init(day: 31.53), pressure: 1009, humidity: 62, weather: [.init(description: "moderate rain")])

    private lazy var cellViewModelValues = [
        "e": [],
        "v": [WeatherListCellViewModel(model: weatherModel1), WeatherListCellViewModel(model: weatherModel2)]
    ]

    func testLoadingSuccessObservable() {
        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)

        let (
            queryEvents,

            expectedCellsEvents,
            expectedErrorEvents
        ) = (
            scheduler.parseEventsAndTimes(timeline: "e---q----", values: stringValues).first!,

            scheduler.parseEventsAndTimes(timeline: "v---v----", values: cellViewModelValues).first!,
            scheduler.parseEventsAndTimes(timeline: "e---e----", values: errorValues).first!
        )

        let repository = WeatherRepository(provider: .init(stubClosure: { _ in .immediate }))

        let query = scheduler.createHotObservable(queryEvents).asObservable()
        let sut = WeatherListViewModel(query: query, repository: repository)

        let recordedCellsEvents = scheduler.record(source: sut.cells.map { $0 as! [WeatherListCellViewModel] })
        let recordedIsLoadingEvents = scheduler.record(source: sut.isLoading)
        let recordedErrorEvents = scheduler.record(source: sut.error)

        scheduler.start()

        XCTAssertEqual(recordedCellsEvents.events, expectedCellsEvents)
        XCTAssertEqual(recordedIsLoadingEvents.events, [
            .next(0, false),
            .next(0, true),
            .next(4, false),
            .next(4, true)
        ])
        XCTAssertEqual(recordedErrorEvents.events, expectedErrorEvents)
    }

    func testLoadingFailed() {
        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)

        let (
            queryEvents,

            expectedCellsEvents,
            expectedErrorEvents
        ) = (
            scheduler.parseEventsAndTimes(timeline: "e---q----", values: stringValues).first!,

            scheduler.parseEventsAndTimes(timeline: "e---e----", values: cellViewModelValues).first!,
            scheduler.parseEventsAndTimes(timeline: "v---v----", values: errorValues).first!
        )

        let testError = NSError(domain: "test error", code: 400, userInfo: nil)
        let repository = WeatherRepository(provider: .init(
            endpointClosure: { target in
                return .init(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkError(testError) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
        },
            stubClosure: { _ in .immediate }))

        let query = scheduler.createHotObservable(queryEvents).asObservable()
        let sut = WeatherListViewModel(query: query, repository: repository)

        let recordedCellsEvents = scheduler.record(source: sut.cells.map { $0 as! [WeatherListCellViewModel] })
        let recordedIsLoadingEvents = scheduler.record(source: sut.isLoading)
        let recordedErrorEvents = scheduler.record(source: sut.error)

        scheduler.start()

        XCTAssertEqual(recordedCellsEvents.events, expectedCellsEvents)
        XCTAssertEqual(recordedIsLoadingEvents.events, [
            .next(0, false),
            .next(0, true),
            .next(4, false),
            .next(4, true)
        ])
        XCTAssertEqual(recordedErrorEvents.events, expectedErrorEvents)
    }
}
