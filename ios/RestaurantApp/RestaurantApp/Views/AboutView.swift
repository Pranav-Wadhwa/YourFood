//
//  AboutView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/30/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            List {
                HStack {
                    AboutText(title: "Pick your favorites.", bodyText: "Tell us the best restaurants you’ve ever visited in the past. We’ll use this info to help you find similar restaurants.", scale: 0.8)
                    
                    Image("Illustration 1")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(maxWidth: 200)
                        
                }
                
                HStack {
                    Image("Illustration 2")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(maxWidth: 200)
                        
                    
                    AboutText(title: "Select a Location.", bodyText: "Want to find something around you? Or are you planning a trip? Either way, select a location to find a restaurant.")
                }
                
                AboutText(title: "We'll do the heavy lifting.", bodyText: "Our machine learning algorithm uses reviews from your favorite restaurants and compares it to reviews from other restaurants in the selected area. The closest match is taken to you.")
                
                Image("Illustration 3")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .padding(.horizontal, 16)
                
                HStack {
                    Image("Illustration 4")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(maxWidth: 150)
                        
                    
                    AboutText(title: "Enjoy your food!", bodyText: "View details about one of our recommendations, pick a restaurant, and enjoy food that’s meant for you, no matter where you are.", scale: 0.85)
                }
            }
        }
    }
}

struct AboutText: View {
    var title: String
    var bodyText: String
    var scale: CGFloat = 0.85
    var body: some View {
        VStack {
            Text(title)
                .padding(.top, 16)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .foregroundColor(.white)
                .font(Font.custom("Prata-regular", size: 20))
                .minimumScaleFactor(scale)
                .lineLimit(1)
            
            Text(bodyText)
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
                .foregroundColor(.white)
                .font(Font.custom("Lato-regular", size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
