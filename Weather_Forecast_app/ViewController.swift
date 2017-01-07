//
//  ViewController.swift
//  Weather_Forecast_app
//
//  Created by Erin Moon on 1/5/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherSearchField: UITextField!
    
    @IBOutlet weak var weatherInfo: UILabel!
    
    @IBAction func searchButton(_ sender: Any) {
        
        if let cityName: String = weatherSearchField.text {
            
            let cityNameSearch = cityName.replacingOccurrences(of: " ", with: "-")
            
            let weatherURL = URL(string: "http://www.weather-forecast.com/locations/\(cityNameSearch)/forecasts/latest")
            
            let request = NSMutableURLRequest(url: weatherURL!)

            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                
                data, response, error in
                
                var message = ""
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparator = "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            
                            if contentArray.count > 1 {
                                
                                stringSeparator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                
                                if newContentArray.count > 1 {
                                    
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "º")
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                if message == "" {
                    
                    message = "404 weather not found"
                    
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.weatherInfo.text = message
                    
                })
            
            }
            
            task.resume()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Touching outside the keyboard hides it.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    //Return key hides the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

}

