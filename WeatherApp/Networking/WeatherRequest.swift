//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import Foundation

struct WeatherRequest: Encodable {
    let q: String
    let cnt = 7
    let appid = "60c6fbeb4b93ac653c492ba806fc346d"
    let units = "metric"
}
