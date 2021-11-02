//
//  ViewController.swift
//  Weather
//
//  Created by Liza Sapsaj on 10/7/21.
//

import UIKit
import CoreLocation
import SwiftUI




class WeatherViewController: UIViewController {
    
    @IBOutlet weak var horizontalScroll: UIStackView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    var weatherView = WeatherView()
    var weatherManager = WeatherManager()
    var weatherManagerDaily = WeatherManagerDaily()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //start updating - updates current location
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        weatherManagerDaily.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}



//MARK: - TextFieldDelegate extension

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type smth"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //get text and set
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            weatherManagerDaily.fetchWeather(cityNameDaily: city)
            
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate extension

extension WeatherViewController: WeatherManagerDelegate, WeatherManagerDailyDelegate {
    func didUpdateWeatherDaily(_ weatherManager: WeatherManagerDaily, weather: WeatherModelDaily) {

        DispatchQueue.main.async {
            self.horizontalScroll.subviews.forEach({$0.removeFromSuperview()})
            for i in 0...weather.dt_txt.count-1 {
                self.weatherView = (Bundle.main.loadNibNamed("WeatherView", owner: nil, options: nil)!.first as? WeatherView)!
                
                print(" dispatch: \(weather.temp[i])")
                self.weatherView.translatesAutoresizingMaskIntoConstraints = false
                self.weatherView.widthAnchor.constraint(equalToConstant: self.horizontalScroll.frame.height).isActive = true
                let sub = weather.dt_txt[i].components(separatedBy: " ")
                let t = sub[1].components(separatedBy: ":")
                self.weatherView.lblDate.text = "   \(sub[0]) \n       \(t[0]):\(t[1])"
                
                self.weatherView.lblTemp.text = "  \(String(weather.temp[i])) °C"
                self.horizontalScroll.addArrangedSubview(self.weatherView)
            }
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}


//MARK: - CLLocation delegate
//kad se pozove reqLocation

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, lonitute: lon)
            weatherManagerDaily.fetchWeather(cityNameDaily: cityLabel.text!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
}

