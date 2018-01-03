//
//  WeatherData.swift
//  Weather
//
//  Created by Sure, Tharun Anand Reddy on 1/3/18.
//  Copyright © 2018 Sure, Tharun. All rights reserved.
//

import UIKit

class WeatherData: NSObject {
    
    func parseData(dictionary: Dictionary<String, Any>) -> Array<Any>{
        var finalString: String
        var finalArray = Array<Any>()
        var humidity = Int()
        var temp_max = Double()
        var temp_min = Double()
        var temp = Double()
        var pressure = Double()
        let name = dictionary["name"]
        let weather = dictionary["weather"] as? Array<Any>
        let weatherDict = weather?.first as? Dictionary<String, Any>
        let description = weatherDict!["description"]
        let icon = weatherDict!["icon"] as? String
        let main = weatherDict!["main"]
        let mainDict = dictionary["main"] as? Dictionary<String, Any>
        if let mainDict = mainDict {
            humidity = mainDict["humidity"] as! Int
            temp_max  = mainDict["temp_max"] as! Double
            temp_min  = mainDict["temp_min"] as! Double
            temp = mainDict["temp"] as! Double
            pressure  = mainDict["pressure"] as! Double
        }
        finalString = "Name: \(name ?? "City Not Found")" + "\nDescription: \(description ?? "Description Not Found")" + "\nMain Weather: \(main ?? "Main Not Found")" + "\nHumidity: \(humidity)" + "\nTemp_Max: \(temp_max)" + "\nTemp_Min: \(temp_min)" + "\nTemp: \(temp)" + "\nPressure: \(pressure)"
        finalArray.append(finalString)
        finalArray.append(icon ?? "10d")
        return finalArray
    }
}
