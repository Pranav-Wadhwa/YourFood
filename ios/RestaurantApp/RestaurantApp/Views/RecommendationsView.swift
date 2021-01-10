//
//  RecommendationsView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/30/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI
import LocationPickerViewController
import CoreData

struct RecommendationsView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(
        entity: FavRestaurant.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavRestaurant.name, ascending: false)]
    ) var visitedRestaurants: FetchedResults<FavRestaurant>
    let categories: [String: Int] = [
        "Delivery": 1,
        "Dine-out": 2,
        "Nightlife": 3,
        "Takeaway": 5,
        "Cafes": 6,
        "Daily Menus": 7,
        "Breakfast": 8,
        "Lunch": 9,
        "Dinner": 10,
        "Pubs & Bars": 11,
        "Pocket Friendly Delivery": 13,
        "Clubs & Lounges": 14,
    ]
    let cuisines = [
        "Any": 0,
        "American": 1,
        "Asian": 3,
        "Barbecue": 193,
        "Bar Food": 227,
        "Burger": 168,
        "French": 45,
        "Healthy": 143,
        "Indian": 148,
        "Italian": 55,
        "Mexican": 73,
        "Pizza": 82,
        "Seafood": 83,
        "Sushi": 177,
        "Thai": 95,
        "Vegetarian": 308
    ]
    @State var shouldShowRecs: Bool = false
    @State var selectedPrices: Set<Int> = [3]
    @State var selectedCuisines: Set<String> = ["Any"]

    
    @State var retrievedRecs: [Recommendation]? = nil
    let cuisineMatrix = [
        ["Any", "American", "Asian", "Barbecue"],
        [ "Bar Food", "Burger", "French", "Healthy"],
        ["Indian", "Italian", "Mexican", "Pizza"],
        ["Seafood", "Sushi", "Thai", "Vegetarian"]
    ]
    @State var currentSelected: Int = 0
    @State private var searchActive: Bool = false
    @State private var selectedLocation: String = "Gainesville, VA"
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @ObservedObject var keyboardObserver = KeyboardResponder()
    private var bottomSafeAreaHeight: CGFloat {
            get {
                if UIApplication.shared.windows.count < 1 {
                    return 0
                }
                return UIApplication.shared.windows[0].safeAreaInsets.bottom
            }
        }
    
    func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
    var body: some View {
        VStack {
            NavigationLink(destination: RecDisplayView(results: self.retrievedRecs ?? []), isActive: $shouldShowRecs) { EmptyView() }
            
            BodyTextCell(bodyText: "Let’s eat! To find a restaurant, select the location you want to search in and some optional filters. Our smart algorithm will do the rest to find a place you’ll love.")
            
            List {
                
                Rectangle()
                .fill(Color.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Button(action: {
                    self.currentSelected = self.currentSelected == 0 ? -1 : 0
                }) {
                    OptionCell(text: "Location", isActive: currentSelected == 0)
                }
                .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))

                
                if self.currentSelected == 0 {
                    
                    VStack(spacing: 0) {
                        Text("Where do you want to eat?")
                            .font(Font.custom("Lato-Black", size: 14))
                            .foregroundColor(Color.white.opacity(0.9))
                            .animation(Animation.linear)
                            .frame(minWidth: 80, maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)
                        
                        HStack(spacing: 0) {
                            TextField("Type a location...", text: $selectedLocation)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                                .padding(8)
                                .background(Color.white)
                                .font(Font.custom("Lato-regular", size: 16))
                            
                            Button(action: {
                                print("Geolocate")
                            }) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 38, height: 38, alignment: .center)
                            .background(Color("Coral"))
                        }
                    }
                    .animation(.default)
                    
                    
                    
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                
                Button(action: {
                    self.currentSelected = self.currentSelected == 1 ? -1 : 1
                }) {
                    OptionCell(text: "Cuisines", isActive: currentSelected == 1)
                }
                .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                if self.currentSelected == 1 {
                    VStack(spacing: 0) {
                        Text("Filter by type of cuisines.")
                            .font(Font.custom("Lato-Bold", size: 14))
                            .foregroundColor(Color.white.opacity(0.9))
                            .animation(Animation.linear)
                            .frame(minWidth: 80, maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 16)
                        
                        
                        VStack(spacing: 16) {
                            ForEach(cuisineMatrix, id: \.self) { cuisineArr in
                                HStack(spacing: 16) {
                                    ForEach(cuisineArr, id: \.self) { cuisineName in
                                        Button(action: {
                                            if self.selectedCuisines.contains(cuisineName) {
                                                self.selectedCuisines.remove(cuisineName)
                                            } else {
                                                self.selectedCuisines.insert(cuisineName)
                                            }
                                        }) {
                                            VStack(spacing: 0) {
                                                Image("Cuisine-\(cuisineName)")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(self.selectedCuisines.contains(cuisineName) ? Color("Coral") : Color.white)
                                                    .frame(height: 44, alignment: .center)
                                                    .padding(.top, 8)
                                                    .animation(Animation.linear)
                                                
                                                Text(cuisineName.uppercased())
                                                    .font(Font.custom("Lato-Bold", size: 12))
                                                    .minimumScaleFactor(0.005)
                                                    .lineLimit(1)
                                                    .padding(.horizontal, 4)
                                                    .padding(.bottom, 8)
                                                    .foregroundColor(self.selectedCuisines.contains(cuisineName) ? Color("Coral") : Color.white)
                                                    .frame(minWidth: 0, maxWidth: .infinity)
                                                    .animation(Animation.linear)
                                            }
                                            
                                        }
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("Coral"), lineWidth: self.selectedCuisines.contains(cuisineName) ? 1.5 : 0))
                                        .background(Color.black.cornerRadius(8))
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                    
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            
                        }
                    }
                    .animation(.default)
                    
                }
                
                Rectangle()
                .fill(Color.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Button(action: {
                    self.currentSelected = self.currentSelected == 2 ? -1 : 2
                }) {
                    OptionCell(text: "Price Range", isActive: currentSelected == 2)
                }
                .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                if self.currentSelected == 2 {
                    HStack(spacing: 16) {
                        ForEach([1, 2, 3, 4, 5], id: \.self) { priceNum in
                            Button(action: {
                                if self.selectedPrices.contains(priceNum) {
                                    self.selectedPrices.remove(priceNum)
                                } else {
                                    self.selectedPrices.insert(priceNum)
                                }
                            }) {
                                
                                Text(String(repeating: "$", count: priceNum))
                                    .font(Font.custom("Lato-Bold", size: 16))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                                    .padding(8)
                                    .foregroundColor(self.selectedPrices.contains(priceNum) ? Color("Coral") : Color.white)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                                    .animation(Animation.linear)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(self.selectedPrices.contains(priceNum) ? Color("Coral") : Color.white, lineWidth:  1.5))
                                    .background(Color.black.cornerRadius(8))
                                
                                
                            }
                            .animation(Animation.linear)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                        }
                    }
                    .animation(Animation.linear)
                    .padding(.top, 16)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                
                Rectangle()
                .fill(Color.white)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
            }
            .background(Color("Charcoal"))
            .buttonStyle(PlainButtonStyle())
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            
            Spacer()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: keyboardObserver.currentHeight - 50 - 64 - bottomSafeAreaHeight, maxHeight: keyboardObserver.currentHeight - 50 - 64 - bottomSafeAreaHeight)
            .edgesIgnoringSafeArea(.bottom)
            
            
            Button(action: {
                self.getRecommendations()
            }) {
                Text("Get Recommendations".uppercased())
                    .font(Font.custom("Lato-bold", size: 18))
                    .tracking(3)
                    .foregroundColor(Color.white)
                    .frame(alignment: .center)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .cornerRadius(8)
                    .background(Color("Coral").cornerRadius(8))
                    .opacity(searchActive ? 0.4 : 1)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .disabled(searchActive)
            }
            .padding(.bottom, 8)
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text(self.alertTitle), message: Text(self.alertMessage))
            }
        }
    
    }
    
    func getCuisineInts() -> [Int] {
        return selectedCuisines.compactMap { str in cuisines[str] }
    }
    
    func getVisited() -> [ZRestaurant] {
        return visitedRestaurants.compactMap { res in ZRestaurant.fromFav(res: res) }
    }
    
    func getRecommendations() {
        if selectedLocation == "" {
            currentSelected = 0
            showAlert(title: "Error", message: "Please enter a valid location")
            return
        }
        if selectedPrices.count == 0 {
            currentSelected = 2
            showAlert(title: "Error", message: "Please select at least one price range")
        }
        searchActive = true
        GeoLocate.getCoords(loc: selectedLocation) { (lat: Double, lon: Double, error: String?) in
            if let error = error {
                self.showAlert(title: "Error", message: error)
                self.searchActive = false
                self.currentSelected = 0
                return
            }
            
            ZRestaurant.getRestaurants(lat: lat, lon: lon, cuisines: self.getCuisineInts()) { (origLocal, error2) in
                
                if let error2 = error2 {
                    self.showAlert(title: "Error", message: error2)
                    self.searchActive = false
                    return
                }
                
                let visited = self.getVisited()
                
                ZRestaurant.getReviews(restaurants: origLocal) { (local) in
                    Recommendation.getRecommendations(visited: visited, local: local) { (recommendations, error3) in
                        
                        if let error3 = error3 {
                            self.showAlert(title: "Error", message: error3)
                            self.searchActive = false
                            return
                        }
                        self.shouldShowRecs = true
                        self.retrievedRecs = recommendations
                        print("Received recommendations")
                        
                    }
                }                
                
            }
            
        }
    }
}

struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension View {

    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: hidden, remove: remove))
    }
}


/// Creates a view modifier to show and hide a view.
///
/// Variables can be used in place so that the content can be changed dynamically.
fileprivate struct HiddenModifier: ViewModifier {

    fileprivate let isHidden: Bool
    fileprivate let remove: Bool

    init(isHidden: Bool, remove: Bool = false) {
        self.isHidden   = isHidden
        self.remove     = remove
    }

    fileprivate func body(content: Content) -> some View {
        Group {
            if isHidden {
                if remove {
                    EmptyView()
                } else {
                    content.hidden()
                }
            } else {
                content
            }
        }
    }
}
