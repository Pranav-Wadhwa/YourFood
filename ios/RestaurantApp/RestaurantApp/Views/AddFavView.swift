//
//  AddFavView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 2/6/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI
import Alamofire
import CoreData
import SwiftyJSON

struct AddFavView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(
        entity: FavRestaurant.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavRestaurant.name, ascending: false)]
    ) var favRestaurants: FetchedResults<FavRestaurant>
    struct FavSearchResult: Identifiable {
        var id: String {
            get {
                return res.id
            }
        }
        var res: ZRestaurant
        var alreadyFavorite: Bool
    }
    @State private var nameText: String = ""
    @State private var locText: String = ""
    @State private var searchResults: [FavSearchResult] = []
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var searchActive: Bool = false
    private let zomatoAPIKey = "69af02457523e03d43165dae8775d384"
    private var textFilled: Bool {
        get {
            return nameText != "" && locText != ""
        }
    }
    private var bottomSafeAreaHeight: CGFloat {
        get {
            if UIApplication.shared.windows.count < 1 {
                return 0
            }
            return UIApplication.shared.windows[0].safeAreaInsets.bottom
        }
    }
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var keyboardObserver = KeyboardResponder()
    var body: some View {
        VStack(spacing: 0) {
            Text("Search for a restaurant:".uppercased())
                .font(Font.custom("Lato-Bold", size: 12))
                .foregroundColor(Color.white.opacity(0.75))
                .padding(.top, 24)
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 16)
                
                TextField("Name", text: $nameText)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                    .padding(8)
                    .background(Color.white)
                    .font(Font.custom("Lato-regular", size: 16))
                                    
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 1, height: 32)
                
                TextField("Location", text: $locText)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                    .padding(8)
                    .background(Color.white)
                    .font(Font.custom("Lato-regular", size: 16))

                
                Spacer()
                    .frame(width: 16)
                
            }
            
            List (searchResults) { result in
                Button(action: {
                    // Add a favorite restaurant from the current cell
                    if !result.alreadyFavorite {
                        ZRestaurant.getReviews(id: result.res.id, completion: { (reviewText: String) in
                            if reviewText == "" {
                                self.showAlert(title: "Error", message: "There are no reviews available for this restaurant, so we can't use it to find similar ones.")
                            }
                            let fav = FavRestaurant(context: self.context)
                            fav.id = result.res.id
                            fav.name = result.res.name
                            fav.address = result.res.address
                            fav.cuisines = result.res.cuisines.joined(separator: ",")
                            fav.reviews = reviewText
                            fav.priceRange = Int32(result.res.priceRange)
                            
                            do {
                                var index = -1
                                for i in 0..<self.searchResults.count {
                                    if self.searchResults[i].res.id == result.id {
                                        index = i
                                    }
                                }
                                if index != -1 {
                                    try self.context.save()
                                    self.searchResults[index].alreadyFavorite = true
                                }
                            } catch {
                                print("error")
                            }
                        })
                    } else {
                        // remove already favorite
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavRestaurant")
                        request.predicate = NSPredicate(format: "id==\(result.res.id)")
                        if let results = try? self.context.fetch(request) {
                            print(results)
                            for object in results {
                                if let obj = object as? NSManagedObject {
                                    print("obj")
                                    self.context.delete(obj)
                                    do {
                                        var index = -1
                                        for i in 0..<self.searchResults.count {
                                            if self.searchResults[i].res.id == result.id {
                                                index = i
                                            }
                                        }
                                        if index != -1 {
                                            try self.context.save()
                                            self.searchResults[index].alreadyFavorite = false
                                        }
                                    } catch {
                                        print("unable to delete")
                                    }
                                     
                                }
                            }
                        } else {
                            print("failed to delete")
                        }
                        
                    }
                    
                }) {
                    ZRestaurantCell(restaurant: result.res, showPlus: true, fullWidth: true, toggled: result.alreadyFavorite)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding(0)
                    
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .padding(0)
                    
                
            }
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .padding(16)
            
            
            Button(action: {
                // perform search
                self.performSearch()
                
            }) {
                HStack(spacing: 0) {
                    Text(searchActive ? "Searching...".uppercased() : "Search".uppercased())
                        .font(Font.custom("Lato-bold", size: 16))
                        .foregroundColor(Color.white)
                        .padding(0)
                    
                    
                    Image(systemName: "magnifyingglass")
                        .font(Font.custom("Lato-regular", size: 18))
                        .foregroundColor(Color.white)
                        .frame(width: 44, height: 44, alignment: .center)
                        .padding(0)
                    
                }
                    .frame(minWidth: 0, maxWidth: .infinity)
                
            }
                .background(Color("Coral"))
                .opacity(searchActive ? 0.4 : textFilled ? 1 : 0.4)
                .frame(minWidth: 0, maxWidth: .infinity)
                .disabled(!textFilled || searchActive)
            
            Spacer()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: keyboardObserver.currentHeight, maxHeight: keyboardObserver.currentHeight)
                .edgesIgnoringSafeArea(.bottom)
            
            Rectangle()
                .fill(Color("Coral"))
                .opacity(searchActive ? 0.4 : textFilled ? 1 : 0.4)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: keyboardObserver.currentHeight == 0 ? bottomSafeAreaHeight : 0, maxHeight: keyboardObserver.currentHeight == 0 ? bottomSafeAreaHeight : 0)
                .edgesIgnoringSafeArea(.bottom)
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text(self.alertTitle), message: Text(self.alertMessage))
                }
            
            


        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .background(Color("Charcoal").edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Add Your Favorite Restaurant")
    }
    
    func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
    
    func performSearch() {
        searchActive = true
        
        GeoLocate.getCoords(loc: self.locText, completion: { (lat: Double, lon: Double, error: String?) -> Void in
            
            if error != nil {
                self.showAlert(title: "Error", message: error!)
                self.searchActive = false
                return
            }
            
            ZRestaurant.getRestaurants(lat: lat, lon: lon, query: self.nameText) { (results, error2) in
                
                if error2 != nil {
                    self.showAlert(title: "Error", message: error2!)
                    self.searchActive = false
                    return
                }
                
                self.searchResults.removeAll()
                
                for result in results {
                    var alreadyFav = false

                    for res in self.favRestaurants {
                        if res.id == result.id {
                            alreadyFav = true
                            break
                        }
                    }
                    
                    self.searchResults.append(FavSearchResult(res: result, alreadyFavorite: alreadyFav))
                }
                
                self.searchActive = false
                
                
            }
            
//            let restaurants =
            
//            let searchParams: [String: Any] = [
//                "apikey": "69af02457523e03d43165dae8775d384",
//                "q": self.nameText,
//                "lat": lat,
//                "lon": lon,
//                "start": 0,
//                "count": 20
//            ]
//            
//            AF.request("https://developers.zomato.com/api/v2.1/search", parameters: searchParams).responseJSON { response in
//                guard let data = response.value as? Dictionary<String, Any> else {
//                    self.searchActive = false
//                    self.showAlert(title: "Error", message: "Unable to retrieve restaurants in this area.")
//                    return
//                }
//                let json = JSON(data)
//                self.searchResults.removeAll()
//                for restaurant in json["restaurants"].array! {
//                    let resObj = restaurant["restaurant"]
//                    let id = String(resObj["R"]["res_id"].stringValue)
//                    var reviews = ""
//                    for review in resObj["all_reviews"]["reviews"].arrayValue {
//                        reviews += review.stringValue
//                    }
//                    let cuisines = resObj["cuisines"].stringValue.split(separator: ",").map( {String($0)})
//                    let name = resObj["name"].stringValue
//                    let address = resObj["location"]["address"].stringValue
//                    let priceRange = resObj["priceRange"].intValue
//                    let result = ZRestaurant(id: id, name: name, cuisines: cuisines, reviews: reviews, address: address, priceRange: priceRange)
//                    
//                    var alreadyFav = false
//                    
//                    for res in self.favRestaurants {
//                        if res.id == result.id {
//                            alreadyFav = true
//                            break
//                        }
//                    }
//                    
//                    self.searchResults.append(FavSearchResult(res: result, alreadyFavorite: alreadyFav))
//                    
//                }
//                
//                self.searchActive = false
            
//            }
        })
        
        
    }
}

struct TextInput: UIViewRepresentable {
    @Binding var text: String
    @State var placeholder: String?

    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.isUserInteractionEnabled = true
        return view
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.returnKeyType = .search
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct AddFavView_Previews: PreviewProvider {
    static var previews: some View {
        AddFavView()
    }
}
