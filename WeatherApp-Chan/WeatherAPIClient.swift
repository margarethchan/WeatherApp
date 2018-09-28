//
//  WeatherAPIClient.swift
//  WeatherApp-Chan
//
//  Created by C4Q on 9/28/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation


class WeatherAPIClient {
    private init() {}
    static let manager = WeatherAPIClient()
    func getWeather(completionHandler: @escaping (Response) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        let accessID = "rBdL16BoxwOaEZtt8vN6q"
        let secretKey = "rp1v5PhP93DiFxMgENYhIPkTZ53Vo94fyRhZIipd"
        let urlStr = "http://api.aerisapi.com/forecasts/11101?client_id=\(accessID)&client_secret=\(secretKey)"
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL); return}
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let weatherInfo = try JSONDecoder().decode(Weather.self, from: data)
                let weatherWrappers = weatherInfo.response[0]
                completionHandler(weatherWrappers)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}
