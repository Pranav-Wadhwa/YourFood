//
//  Recommendations.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 3/5/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

struct Recommendation: Identifiable {
    var id: String {
        get {
            return restaurant.id
        }
    }
    var restaurant: ZRestaurant
    var recLevel: Double
    static func getRecommendations(visited: [ZRestaurant], local: [ZRestaurant], completion: @escaping (([Recommendation], String?) -> Void)) {
        
        var results = [Recommendation]()
        
        var ref: DatabaseReference = Database.database().reference()
        ref = ref.childByAutoId()
        
        ref.updateChildValues([
            "visited": ZRestaurant.getReviewString(restaurants: visited),
            "local": ZRestaurant.getReviewString(restaurants: local)
        ]) { (error, resultRef) in
            if let error = error {
                completion(results, error.localizedDescription)
                return
            }
            
            print(ref.key ?? "no key")
            
            AF.request("https://pranavwadhwa.pythonanywhere.com/", parameters: ["dataid":ref.key]).responseJSON { response in
                print("RESPONSE")
                print(response)
                guard let data = response.value as? Dictionary<String, Any> else {
                    print("No python anywhere response")
                    completion(results, "Unable to retrieve recommendations")
                    return
                }
                
                for restaurant in local {
                    results.append(Recommendation(restaurant: restaurant, recLevel: data[restaurant.id] as! Double))
                    print("Recommmendation for \(restaurant.name) = \(String(describing: data[restaurant.id]))")
                }
                
                results.sort { (a, b) -> Bool in
                    return a.recLevel >= b.recLevel
                }

                completion(results, nil)

            }
            
        }
        
        
    }
}
