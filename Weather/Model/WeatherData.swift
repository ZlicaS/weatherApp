//
//  WeatherData.swift
//  Weather
//
//  Created by Liza Sapsaj on 10/7/21.
//

import Foundation

struct WeatherData: Codable {
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct DailyWeather:Codable{
    let list:[List]
}

struct Main: Codable {
    let temp: Double   //list[0].main.temp
    
}

struct Weather:Codable {
    let description:String
    let id:Int
}

struct WeatherDaily: Codable{
    let message:String
}

struct List: Codable {
    let main: Main
    let dt_txt: String
}




