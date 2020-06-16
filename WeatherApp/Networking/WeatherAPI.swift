//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import Moya

enum WeatherAPI {
    case list(WeatherRequest)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.openweathermap.org")!
    }

    var path: String {
        switch self {
        case .list:
            return "data/2.5/forecast/daily"
        }
    }

    var method: Method {
        .get
    }

    var sampleData: Data {
        switch self {
        case .list:
            return #"{"city":{"id":1580578,"name":"Ho Chi Minh City","coord":{"lon":106.6667,"lat":10.8333},"country":"VN","population":0,"timezone":25200},"cod":"200","message":4.2297425,"cnt":7,"list":[{"dt":1592280000,"sunrise":1592260285,"sunset":1592306204,"temp":{"day":33,"min":27.89,"max":33,"night":27.89,"eve":32.44,"morn":33},"feels_like":{"day":37.04,"night":31.95,"eve":36.23,"morn":37.04},"pressure":1007,"humidity":59,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"speed":2.46,"deg":183,"clouds":75,"rain":5.75},{"dt":1592712000,"sunrise":1592692342,"sunset":1592738270,"temp":{"day":31.53,"min":26.2,"max":32.81,"night":26.92,"eve":31.67,"morn":26.2},"feels_like":{"day":34.32,"night":30.62,"eve":34.4,"morn":30.27},"pressure":1009,"humidity":62,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"speed":3.79,"deg":249,"clouds":79,"rain":4.02}]}"#.data(using: .utf8) ?? Data()
        }
    }

    var task: Task {
        switch self {
        case let .list(request):
            let params: [String: Any] = [
                "q": request.q,
                "cnt": request.cnt,
                "appid": request.appid,
                "units": request.units
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding())
        }
    }

    var headers: [String : String]? {
        nil
    }
}
