//
//  HomeScreenViewDelegate.swift
//  WeatherApp
//
//  Created by mac on 10/02/2021.
//

import Foundation

protocol HomeScreenViewDelegate: NSObjectProtocol {
    func displayWeatherInformation(dailyModel:[DailyModel],hourlyModel:[HoulyModel])
    func loadWeatherDataFromFile() -> WeatherModel?
    func setTemperatureLabel(weatherModel:WeatherListModel)
}
