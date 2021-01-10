//
//  GeoLocate.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 3/5/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import Foundation
import Alamofire

struct GeoLocate {
    static func getCoords(loc: String, completion: @escaping ((Double, Double, String?) -> Void)) {
        let geocodeParams: [String: Any] = [
            "key": "9137baf2923040c19ec65a6c7ed50ef0",
            "q": loc,
            "limit": 1
        ]
        
        AF.request("https://api.opencagedata.com/geocode/v1/json", parameters: geocodeParams).responseJSON { (response) in
            let failureMessage = "Unable to find the entered location. Please check your spelling or be more specific"
            guard let data = response.value as? Dictionary<String, Any> else {
                completion(0, 0, failureMessage)
                return
            }
            guard let results = data["results"] as? [[String: Any]] else {
                completion(0, 0, failureMessage)
                return
            }
            if results.count == 0 {
                completion(0, 0, failureMessage)
                return
            }
            guard let geometry = results[0]["geometry"] as? [String: Any] else {
                completion(0, 0, failureMessage)
                return
            }
            let lat = geometry["lat"]! as! Double
            let lon = geometry["lng"]! as! Double
            completion(lat, lon, nil)
        }
        
    }
}
