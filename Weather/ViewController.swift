//
//  ViewController.swift
//  Weather
//
//  Created by Sure, Tharun Anand Reddy on 1/2/18.
//  Copyright © 2018 Sure, Tharun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dataTextView: UITextView!
    let dataManager = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cityTextField.delegate = self
        let defaults = UserDefaults.standard
        cityTextField.text = defaults.object(forKey: "cityText") as? String
    }
    
    //to download data from url
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    //download image
    func downloadImage(url: URL) {
        print("Download Image Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Image Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func parseJSON() {
        
        let apiKey = "4ff8d8a1f1aa80952e11b30ead5f0528"
        let city: String = cityTextField.text!
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city),us&APPID=\(apiKey)")
        
        if let url = url {
            getDataFromUrl(url: url) { data, response, error in
                print("Download Started")
                guard error == nil else {
                    print("returning error")
                    return
                }
                
                guard let content = data else {
                    print("not returning data")
                    return
                }
                
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary<String, Any> else {
                    print("Error in JSONSerialization")
                    return
                }
                
                let data = self.dataManager.parseData(dictionary: json)
                print(data)
                print("Download Finished")
                self.downloadImageFromUrl(icon: data)
            }
        }
        else{
         print("URL is nil")
        }
        
    }
            
    func downloadImageFromUrl(icon: Array<Any>) {
        
        let stringData = icon.first as? String
        let iconData = icon[1] 
        
        let imageUrl = URL(string:"http://openweathermap.org/img/w/\(iconData).png")
        if let imageUrl = imageUrl {
            downloadImage(url: imageUrl)
                DispatchQueue.main.async {
                    self.dataTextView.text = stringData
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    
    // MARK: - TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let defaults = UserDefaults.standard
        defaults.set(cityTextField.text, forKey: "cityText")
        defaults.synchronize()
        //parse the data
        parseJSON()
        return true
    }
}


