//
//  HomeScreenPresenter.swift
//  WeatherApp
//
//  Created by mac on 09/02/2021.
//

import Foundation
import CoreLocation
class HomeScreenPresenter{
    
    //Mark:-Valiables
    var hourlyModel:[HoulyModel]=[]
    var dailyModel:[DailyModel]=[]
    weak private var homeScreenViewDelegate : HomeScreenViewDelegate?
    
    private let dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    private let hourFormatter :DateFormatter = {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "ha"
        return hourFormatter
    }()
    
    
    //Mark:Methods
    
    func setViewDelegate(homeScreenViewDelegate:HomeScreenViewDelegate?){
        self.homeScreenViewDelegate = homeScreenViewDelegate
    }
    
    
    private func filterWeatherResponse(weatherModel:WeatherModel){
        if let list = weatherModel.list{
            
            for index in 0..<list.count{
                let imageIcon =  list[index].weather[0].icon
                let dayDes =  list[index].weather[0].description
                let weekDay = Date(timeIntervalSince1970: TimeInterval(list[index].dt))
                let dailyWeek = dateFormatter.string(from: weekDay)
                let dailyHigh = Int(list[index].main.temp_max)
                let dailyLow = Int(list[index].main.temp_min)
                let hour = hourFormatter.string(from: weekDay)
                let hourlyTemperature = Int(list[index].main.temp.rounded())
                
                let Day = DailyModel(dailyIcon: imageIcon, dailyWeekDay: dailyWeek, dailyHigh: dailyHigh, dailyLow: dailyLow, description: dayDes)
                let houlyObj = HoulyModel(hour: hour, Temperature: hourlyTemperature, hourlyIcon: imageIcon)
                dailyModel.append(Day)
                hourlyModel.append(houlyObj)
            }
        }
        
    }
    
    func loadDataToSwitchBtn(){
        self.filterWeatherResponse(weatherModel: (homeScreenViewDelegate?.loadWeatherDataFromFile()!)!)
        self.homeScreenViewDelegate?.displayWeatherInformation(dailyModel: self.dailyModel, hourlyModel: self.hourlyModel)
    }
    
    
    func getLocation(latitude : CLLocationDegrees,longitude: CLLocationDegrees){
        let url = "https://api.openweathermap.org/data/2.5/weather?appid=\(Constants.APIDetails.AppId)&units=metric&lat=\(latitude)&lon=\(longitude)"
        ApiService.instance.dataRequest(url: url, objectType: WeatherListModel.self, params: nil, method: "Get") {[weak self ] (response) in
            switch response{
            case .success(let weatherModel):
                
                guard let self = self else {return}
                self.homeScreenViewDelegate?.setTemperatureLabel(weatherModel: weatherModel)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                break
                
            }
        }
        
    }
    
    func getCityInformation(CityName:String){
        
        let url = "https://api.openweathermap.org/data/2.5/forecast?q=\(CityName)&appid=\(Constants.APIDetails.AppId)"
        
        ApiService.instance.dataRequest(url:url  , objectType:WeatherModel.self, params: nil, method: "GET") { [weak self] (response) in
            switch response{
            case .success(let weatherModel):
                
                guard let self = self else {return}
                self.filterWeatherResponse(weatherModel: weatherModel)
                self.homeScreenViewDelegate?.displayWeatherInformation(dailyModel: self.dailyModel, hourlyModel: self.hourlyModel)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break

            }
        }
    }
    
}
