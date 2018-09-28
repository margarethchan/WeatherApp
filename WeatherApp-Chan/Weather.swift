//
//  Weather.swift
//  WeatherApp-Chan
//
//  Created by C4Q on 9/28/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let response: [Response]
}

struct Response: Codable {
    let periods: [Day]
}

struct Day: Codable {
    let dateTimeISO: String
    let maxTempC, maxTempF, minTempC, minTempF: Int
    let icon: String
}
