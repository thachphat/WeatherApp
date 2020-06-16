//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol WeatherRepositoryProtocol {
    func getWeatherList(query: String?) -> Single<Result<[WeatherModel], Error>>
}

final class WeatherRepository {
    private let provider: MoyaProvider<WeatherAPI>
    init(provider: MoyaProvider<WeatherAPI>) {
        self.provider = provider
    }
}

extension WeatherRepository: WeatherRepositoryProtocol {
    func getWeatherList(query: String?) -> Single<Result<[WeatherModel], Error>> {
        let request = WeatherRequest(q: query ?? "")
        return provider.rx.request(.list(request))
            .map([WeatherModel].self, atKeyPath: "list")
            .map { .success($0) }
            .catchError { .just(.failure($0)) }
    }
}
