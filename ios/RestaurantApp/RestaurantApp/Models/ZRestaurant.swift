//
//  ZRestaurant.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 2/25/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ZRestaurant: Identifiable {
    var id: String
    var name: String
    var cuisines: [String]
    var reviews: String
    var address: String
    var priceRange: Int
    
    static func getReviews(id: String, completion: @escaping (String) -> Void) {
        let searchParams: [String: Any] = [
            "apikey": "69af02457523e03d43165dae8775d384",
            "res_id": id,
        ]
        AF.request("https://developers.zomato.com/api/v2.1/reviews", parameters: searchParams).responseJSON { response in
            guard let data = response.value as? Dictionary<String, Any> else {
                print("No zomato data")
                print("Unable to retrieve reviews")
                return
            }
            let json = JSON(data)
            let reviews = json["user_reviews"].arrayValue
            if reviews.count == 0 {
                print("No reviews")
                completion("")
                return
            }
            var reviewText = ""
            for review in reviews {
                reviewText += review["review"]["review_text"].stringValue
            }
            completion(reviewText)
            
        }
    }
    
    static func getReviews(restaurants: [ZRestaurant], completion: @escaping ([ZRestaurant]) -> Void) {
        
        
        var newRestaurants = [ZRestaurant]() {
            didSet {
                if newRestaurants.count == restaurants.count {
                    completion(newRestaurants)
                }
            }
        }
        for res in restaurants {
            getReviews(id: res.id) { (reviews) in
                newRestaurants.append(ZRestaurant(id: res.id, name: res.name, cuisines: res.cuisines, reviews: reviews, address: res.address, priceRange: res.priceRange))
            }
        }
        
    }
    
    static func fromFav(res: FavRestaurant) -> ZRestaurant {
        return ZRestaurant(id: res.id ?? "", name: res.name ?? "", cuisines: res.cuisines?.split(separator: ",").map( { String($0) }) ?? [], reviews: res.reviews ?? "", address: res.address ?? "", priceRange: Int(res.priceRange))
    }
    
    static func getReviewString(restaurants: [ZRestaurant]) -> String {
        var reviews = ""
        for i in 0..<restaurants.count {
            let restaurant = restaurants[i]
            reviews += restaurant.id + ";" + restaurant.name + " - " + restaurant.reviews.replacingOccurrences(of: ";", with: "").replacingOccurrences(of: "|", with: "") + (i == restaurants.count - 1 ? "" : "|")
        }
        return reviews
    }
    
    static func getRestaurants(lat: Double, lon: Double, query: String = "", cuisines: [Int] = [], completion: @escaping (([ZRestaurant], String?) -> Void)) {
        var results = [ZRestaurant]()
        let searchParams: [String: Any] = [
            "apikey": "69af02457523e03d43165dae8775d384",
            "q": query,
            "lat": lat,
            "lon": lon,
            "start": 0,
            "cuisines": cuisines.compactMap { String($0) }
        ]
        
        AF.request("https://developers.zomato.com/api/v2.1/search", parameters: searchParams).responseJSON { response in
            guard let data = response.value as? Dictionary<String, Any> else {
                completion(results, "Unable to retrieve restaurants in this area.")
                return
            }
            let json = JSON(data)
            for restaurant in json["restaurants"].array! {
                let resObj = restaurant["restaurant"]
                let id = String(resObj["R"]["res_id"].stringValue)
                var reviews = ""
                for review in resObj["all_reviews"]["reviews"].arrayValue {
                    reviews += review["review"].stringValue
                }
                let cuisines = resObj["cuisines"].stringValue.split(separator: ",").map( {String($0)})
                let name = resObj["name"].stringValue
                let address = resObj["location"]["address"].stringValue
                let priceRange = resObj["priceRange"].intValue
                let result = ZRestaurant(id: id, name: name, cuisines: cuisines, reviews: reviews, address: address, priceRange: priceRange)
                
                results.append(result)
                
            }
            
            completion(results, nil)
        
        }
    }
    
}
