//
//  ViewController.swift
//  WeatherApp
//
//  Created by mac on 08/02/2021.
//

import UIKit
import CoreLocation


class HomeScreenView: UIViewController {
    
    //Mark:-Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    //Mark:-Variables
    let locationManager = CLLocationManager()
    let presenter = HomeScreenPresenter()
    var long :CLLocationDegrees?
    var lat:CLLocationDegrees?
    var dailyArr = [DailyModel]()
    var hourlyArr = [HoulyModel]()
    
    //Mark:-Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        locationRequest()
        registerTableViewCell()
        presenter.setViewDelegate(homeScreenViewDelegate: self)
    }
    
    func registerTableViewCell(){
        let cellNib = UINib(nibName:"WeatherCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "WeatherCell")
    }
    
    func setDelegates(){
        searchTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    func locationRequest(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func switchDidTap(_ sender: Any) {
        
        if ((sender as AnyObject).isOn == true) {
            presenter.loadDataToSwitchBtn()
            
        } else {
            if let city = searchTextField.text {
                presenter.getCityInformation(CityName:city)
                
            }
        }
    }
    
    @IBAction func searchBtnDidTap(_ sender: Any) {
        if let city = searchTextField.text {
            presenter.getCityInformation(CityName:city)
        }
    }
}



extension HomeScreenView :HomeScreenViewDelegate{
    
    func setTemperatureLabel(weatherModel: WeatherListModel) {
        TemperatureLabel.text = "\(weatherModel.main.temp)"
        cityLabel.text = weatherModel.name
        
    }
    
    func displayWeatherInformation(dailyModel: [DailyModel], hourlyModel:[HoulyModel]) {
        
        for item in dailyModel{
            dailyArr.append(item)
            
        }
        for item in hourlyModel{
            hourlyArr.append(item)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }}
    
    
    func loadWeatherDataFromFile() -> WeatherModel? {
        let path = Bundle.main.path(forResource: "weatherResponse", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        
        return try? JSONDecoder().decode(WeatherModel.self, from: data)
    }
    
    
}

//MARK: - UITextFieldDelegate

extension HomeScreenView: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            presenter.getCityInformation(CityName:city)
            
        }
        
        searchTextField.text = ""
        
    }
}
//MARK: - CLLocationManagerDelegate


extension HomeScreenView: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            presenter.getLocation(latitude: lat!, longitude: long!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


extension HomeScreenView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            cell.cellDelegate = self
            cell.setupView()
            cell.setWeatherCell(dailyModel: dailyArr[indexPath.row], hourlyModel:hourlyArr)
            return cell
        }
        return WeatherCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}

//Mark:- CollectionViewCellDelegate

extension HomeScreenView:CollectionViewCellDelegate{
    func collectionView(collectionviewcell: WeatherCollectionViewCell?, index: Int, didTappedInTableViewCell: WeatherCell) {
        print ("cell seleted")
    }
    
    
}


