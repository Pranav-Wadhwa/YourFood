//
//  TabBar.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/30/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @State var parent: HomeView
    @State var selectedTab = 0
    var body: some View {
        
        ZStack {
            VStack {
                
                Spacer()
                .frame(height: 13, alignment: .bottom)

                Rectangle()
                    .fill(Color("Coral"))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 2, maxHeight: 2)
                    .animation(Animation.linear.speed(1.5))

                Spacer()
                    .frame(height: 49, alignment: .bottom)
            }            
            
            HStack(spacing: 0) {
                Button(action: {
                    self.parent.updateTab(newTab: 0)
                    self.selectedTab = 0
                }) {
                    VStack {
                        Spacer()
                            .frame(height: 14)
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(selectedTab == 0 ? Color("Coral") : Color.white)
                            .font(Font.system(size: 28))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            .animation(Animation.linear.speed(1.5))
                    }
                    
                        
                    
                }
                
                Button(action: {
                    self.parent.updateTab(newTab: 1)
                    self.selectedTab = 1
                }) {
                    HStack {
                        Image(selectedTab == 1 ? "tabCenter" : "tabCenterWhite")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .animation(Animation.linear.speed(1.5))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 64, maxHeight: 64)

                }

                Button(action: {
                    self.parent.updateTab(newTab: 2)
                    self.selectedTab = 2
                }) {
                    VStack {
                        Spacer()
                            .frame(height: 14)
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(selectedTab == 2 ? Color("Coral") : Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            .font(Font.system(size: 28))
                            .animation(Animation.linear.speed(1.5))
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: Alignment.bottom)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
