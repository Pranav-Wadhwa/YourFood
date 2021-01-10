//
//  ZRestaurantCell.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 2/4/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI

struct ZRestaurantCell: View {
    var restaurant: ZRestaurant
    var showPlus: Bool = false
    var fullWidth: Bool = false
    var toggled: Bool = false
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if !showPlus {
                        Spacer()
                            .frame(height: 8)
                    }
                    Text(restaurant.name)
                        .font(Font.custom("Lato-Bold", size: 14))
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(fullWidth ? .trailing : .horizontal, 16)
                    Text(restaurant.cuisines.joined(separator: ", "))
                        .font(Font.custom("Lato-Regular", size: 12))
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(fullWidth ? .trailing : .horizontal, 16)
                    Text(restaurant.address)
                        .font(Font.custom("Lato-Regular", size: 12))
                        .foregroundColor(Color.white)
                        .lineLimit(nil)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(fullWidth ? .trailing : .horizontal, 16)

                }
                if showPlus {
                    if toggled {
                        Image(systemName: "xmark.circle")
                        .foregroundColor(Color("Coral"))
                        .font(Font.system(size: 20))
                    } else {
                        Image(systemName: "plus.circle")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 20))
                    }
                }
            }
            Rectangle()
                .fill(Color.white.opacity(0.75))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
            if !showPlus {
                Spacer()
                    .frame(height: 8)
            }

        }
        
    }
}

struct AddFavRestaurantCell: View {
    var destination: AddFavView!
    var body: some View {
        ZStack {
            NavigationLink(destination: self.destination ?? AddFavView()) {
                EmptyView()
            }
            VStack {
                Rectangle()
                    .fill(Color("Coral"))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                
                HStack {
                    Text("Add a restaurant")
                    .font(Font.custom("Lato-Black", size: 14))
                    .foregroundColor(Color("Coral"))
                    .lineLimit(nil)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                    .foregroundColor(Color("Coral"))
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                
                Rectangle()
                    .fill(Color("Coral"))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
            }
                .background(Color("Charcoal"))
            
        }
    
    }
}

