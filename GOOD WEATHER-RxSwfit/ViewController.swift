//
//  ViewController.swift
//  GOOD WEATHER-RxSwfit
//
//  Created by IwasakIYuta on 2022/01/13.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hnmidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //入力される間にフェッチされる
        cityNameTextField.rx.value
            .subscribe(onNext: { city in
   //同じコントローラーだけだから [ weak self ]付けなくてもいいらしい
                if let city = city {
                    if city.isEmpty {
                        self.displaycity(nil)//cityが空もしくは検索が不可能な場合はnilを入れる
                    } else {
                        self.fetchweather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    
    private func fetchweather(by city: String) {
      
       guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
             let url = URL.urlForWeatherAPI(city: cityEncoded) else { return }
        let resource = Resource<WeatherResult>(url: url)
        URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)//DispatchQueueの代わりにできる通信が完了して切り替える必要があるため
            .catchAndReturn(WeatherResult.empty)//エラーだった場合//天気がからな場合はない
            .subscribe(onNext: { weather in
                
                let weather = weather.main
                self.displaycity(weather)//ここでweatherが入るので表示する事ができる

            }).disposed(by: disposeBag) //.catchAndReturn(WeatherResult)でエラーをキャッチできるらしい
        
    }
    
    private func displaycity(_ weather: Weather?) {
        
        if let weather = weather {
            temperatureLabel.text = "\(weather.temp) ℉ "
            hnmidityLabel.text = "\(weather.humidity) 💦"
        } else {
            temperatureLabel.text = "😳"
            hnmidityLabel.text = "🚫"
            
        }
        
    }
  


}

