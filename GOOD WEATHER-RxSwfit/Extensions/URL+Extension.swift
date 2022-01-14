//
//  URL+Extension.swift
//  GOOD WEATHER-RxSwfit
//
//  Created by IwasakIYuta on 2022/01/14.
//

import Foundation

extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&lang=ja&appid=\(API_KEY)")
        
    }
    
}
