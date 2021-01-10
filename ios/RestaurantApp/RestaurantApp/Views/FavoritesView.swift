//
//  FavoritesView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/30/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(
        entity: FavRestaurant.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavRestaurant.name, ascending: false)]
    ) var favRestaurants: FetchedResults<FavRestaurant>
    @State private var isActive = true
    @State private var showingActions = false
    @State private var selectedRestaurant: String?
    
    var body: some View {
        VStack {
            Spacer().frame(height: 8)
            HeaderCell(headerText: "Your Favorite Places to Eat.")
            BodyTextCell(bodyText: "Tell us what places where you’ve enjoyed eating before, so we can learn a bit about your tastes and preferences.")
            Spacer().frame(height: 16)
            if favRestaurants.count == 0 {
                VStack {
                    Spacer()
                    NavigationLink(destination: AddFavView()) {
                        Text("No favorites yet.\nTap to add one!")
                            .font(Font.custom("Lato-semibold", size: 16))
                            .foregroundColor(Color("Coral"))
                            .multilineTextAlignment(.center)
                    }
                    .frame(alignment: .center)
                    Spacer()
                }
            } else {
                List {
                    AddFavRestaurantCell()
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        
                    ForEach(favRestaurants) { restaurant in
                        Button(action: {
                            print("show options")
                            self.showingActions = true
                            self.selectedRestaurant = restaurant.id
                        }) {
                            ZRestaurantCell(restaurant: ZRestaurant.fromFav(res: restaurant))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .actionSheet(isPresented: self.$showingActions) { () -> ActionSheet in
                            
                            var index = -1
                            for i in 0..<self.favRestaurants.count {
                                if self.favRestaurants[i].id == self.selectedRestaurant {
                                    index = i
                                    break
                                }
                            }
                            if index == -1 { return ActionSheet(title: Text("Error"), message: Text(""), buttons: [.default(Text("Close"))]) }
                            
                            return ActionSheet(
                                title: Text("\(self.favRestaurants[index].name ?? "Restaurant")"),
                                buttons: [
                                    .default(Text("Read Reviews"), action: {
                                        
                                    }),
                                    .default(Text("Get Directions"), action: {
                                        
                                    }),
                                    .destructive(Text("Remove Favorite"), action: {
                                        self.deleteFavorite(id: self.selectedRestaurant!)
                                    }),
                                    .cancel()
                            ])
                        }
                    }
                }
            }
            
        }
    }
    
    func deleteFavorite(id: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavRestaurant")
        request.predicate = NSPredicate(format: "id==\(id)")
        if let results = try? self.context.fetch(request) {
            for object in results {
                if let obj = object as? NSManagedObject {
                    self.context.delete(obj)
                    do {
                        try self.context.save()
                    } catch {
                        print("unable to delete")
                    }
                     
                }
            }
        } else {
            print("failed to delete")
        }
    }

}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
