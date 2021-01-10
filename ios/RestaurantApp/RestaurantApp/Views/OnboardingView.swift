//
//  ContentView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/23/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
        
    var currentIndex: Int! = 0
    @State var pager = PageViewController(viewControllers: [
        UIHostingController(rootView: OnboardingSubview(titleText: "YourFood", bodyText: "Discover more of what you love.", imageName: "bg1", isFirst: true, tag: 0)),
        UIHostingController(rootView: OnboardingSubview(titleText: "Eat What You Love.", bodyText: "YourFood uses a smart AI algorithm to easily find restaurants you’ll enjoy.", imageName: "bg2", tag: 1)),
        UIHostingController(rootView: OnboardingSubview(titleText: "Get Rid of Long Lists.", bodyText: "Tired of scrolling through lengthy lists of restaurants you’re not interested in? Get personalized recommendations with YourFood.", imageName: "bg3", tag: 2)),
        UIHostingController(rootView: OnboardingSubview(titleText: "Find Food Faster.", bodyText: "Simply tell us where you’ve eaten in the past and our AI will find places near you where you’ll love to eat.", imageName: "bg4", hasButton: true, tag: 3))
    ])

    mutating func onboardPageChanged(newIndex: Int) {
        self.currentIndex = newIndex
    }
    
    var body: some View {
        ZStack {
            
            Color.black
            .edgesIgnoringSafeArea(.all)
            
            pager
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.horizontal)
            .edgesIgnoringSafeArea(.vertical)
            
            
            VStack {
                Spacer()
                
                HStack {
                    Rectangle()
                        .fill(currentIndex == 0 ? Color("Coral") : Color.white)
                        .frame(width: 24, height: 2)
                        .animation(Animation.linear.speed(1.5))

                    Rectangle()
                        .fill(currentIndex == 1 ? Color("Coral") : Color.white)
                        .frame(width: 24, height: 2)
                        .animation(Animation.linear.speed(1.5))

                    Rectangle()
                        .fill(currentIndex == 2 ? Color("Coral") : Color.white)
                        .frame(width: 24, height: 2)
                        .animation(Animation.linear.speed(1.5))

                    Rectangle()
                        .fill(currentIndex == 3 ? Color("Coral") : Color.white)
                        .frame(width: 24, height: 2)
                        .animation(Animation.linear.speed(1.5))
                    
                    
                }
                Spacer()
                    .frame(height: 16)
            }
            
            
        }
        
        
    }
    
}


struct OnboardingSubview: View {
    var titleText: String
    var bodyText: String
    var imageName: String
    var isFirst: Bool = false
    var hasButton: Bool = false
    var tag: Int

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.vertical)
            
            VStack {
                
                if hasButton {
                    Spacer()
                        .frame(height: 225)
                }
                
                getTitle(text: titleText, first: isFirst)

                Spacer()
                    .frame(height: 8)

                Text(bodyText)
                    .lineLimit(nil)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(Font.custom("Lato-regular", size: 16))
                        .foregroundColor(Color.white.opacity(0.8))
                    .padding()
                    .multilineTextAlignment(.center)
                
                if hasButton {
                    Spacer()
                        .frame(height: 175)
    
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "hasOnboarded")
                    }) {
                        Text("Get Started".uppercased())
                            .font(Font.custom("Lato-bold", size: 18))
                            .tracking(3)
                            .foregroundColor(Color("Coral"))
                            .frame(width: 250, height: 50, alignment: .center)
                            .border(Color("Coral"), width: 2)
                            .cornerRadius(4)
                            .background(Color.black.opacity(0.5))
                    }
                    Text("No Account required".uppercased())
                        .font(Font.custom("Lato-semibold", size: 11))
                        .tracking(3)
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding(.top, 16)
                    
                    Spacer()
                        .frame(height: 32)
                    
                }
            }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        
    }
    
    func getTitle(text: String, first: Bool) -> Text {
        if first {
            return Text(text)
                .font(Font.custom("Prata-regular", size: 40.0))
                .foregroundColor(.white)
        }
        return Text(text)
            .font(Font.custom("Prata-regular", size: 30.0))
            .foregroundColor(.white)
    }
    
    
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

extension UserDefaults {
    @objc dynamic var hasOnboarded: Bool {
        return bool(forKey: "hasOnboarded")
    }
}
