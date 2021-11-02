//
//  WeatherManagerDaily.swift
//  Weather
//
//  Created by Liza Sapsaj on 10/28/21.
//

import Foundation


protocol WeatherManagerDailyDelegate {
    func didUpdateWeatherDaily(_ weatherManager: WeatherManagerDaily, weather: WeatherModelDaily)
}


struct WeatherManagerDaily{
    
    let weatherDailyURL = "https://api.openweathermap.org/data/2.5/forecast?appid=4613cd0a7687f546d96c96617b02cd4c&units=metric"
    
    var delegate: WeatherManagerDailyDelegate?
    
    
    func fetchWeather(cityNameDaily: String) {
        if(cityNameDaily.contains(" ")){
            let newString = cityNameDaily.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let urlString = "\(weatherDailyURL)&q=\(newString)"
            performRequest(urlString: urlString)
        }else{
            let urlString = "\(weatherDailyURL)&q=\(cityNameDaily)"
            performRequest(urlString: urlString)
        }
    }
    
    func performRequest(urlString :String){
        //create url
        
        if  let url = URL(string: urlString){
            //create urlSession
            let session = URLSession(configuration: .default)
            //give session task
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    
                    
                    
                    if let weather = self.parseJSONDaily(safeData){
                        self.delegate?.didUpdateWeatherDaily(self, weather: weather)
                    }
                    
                    
                }
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseJSONDaily(_ weatherData: Data) -> WeatherModelDaily?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(DailyWeather.self, from: weatherData)
            
            
            var allTemp = [Double]()
            var allDate = [String]()
            let tem = decodedData.list[0].main.temp
            let dat = decodedData.list[0].dt_txt
            
            for i in 0...decodedData.list.count-1{
                allTemp.append(decodedData.list[i].main.temp)
                allDate.append(decodedData.list[i].dt_txt)
                
            }
            print("2 parse tem: \(tem) i datum: \(dat)")
            let weather = WeatherModelDaily(temp: allTemp, dt_txt: allDate)
            
            return weather
            
            
        } catch {
            print("error")
            return nil
        }
    }
    
}
