//
//  WeatherData.swift
//  Weather
//
//  Created by Liza Sapsaj on 10/7/21.
//

import Foundation

struct WeatherData: Codable { //endocable+decodable
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather:Codable {
    let description:String
    let id:Int
}
