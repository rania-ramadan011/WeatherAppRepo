//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by mac on 09/02/2021.
//

import Foundation


struct Main: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let humidity: Float
}

struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct DailyModel{
    var dailyIcon:String
    var dailyWeekDay:String
    var dailyHigh:Int
    var dailyLow:Int
    var description:String
    
}
struct HoulyModel{
    var hour:String
    var Temperature:Int
    var hourlyIcon:String
}
struct WeatherModel: Codable {
  
	let list: [WeatherListModel]?
//
//    enum Response: Decodable {
//
//        enum DecodingError: Error {
//            case wrongJSON
//        }
//
//        case weather(Weather)
//        case main(Main)
//        case sys(Sys)
//
//        enum CodingKeys: String, CodingKey {
//            case weather = "Weather"
//            case main = "Main"
//            case sys = "Sys"
//        }
//
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            switch container.allKeys.first {
//            case .weather:
//                let value = try container.decode(Weather.self, forKey: .weather)
//                self = .weather(value)
//            case .main:
//                let value = try container.decode(Main.self, forKey: .main)
//                self = .main(value)
//            case .sys:
//                let value = try container.decode(Sys.self, forKey: .sys )
//                self = .sys(value)
//            case .none:
//                throw DecodingError.wrongJSON
//            }
//        }
//    }

}
       
         
        


struct WeatherListModel: Codable {
	let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String?
    let dt: Int
    let timezone: Int?
    let dt_txt: String?
}

