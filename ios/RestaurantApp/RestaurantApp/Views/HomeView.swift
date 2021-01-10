//
//  HomeView.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/30/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @State private var currentTab = 0
    
    private var navTitle: String {
        get {
            switch currentTab {
            case 0:
                return "Favorites2"
            case 1:
                return "Recommendations"
            case 2:
                return "Settings"
            default:
                return "RestaurantApp"
            }
        }
    }
    
    mutating func updateTab(newTab: Int) {
        self.currentTab = newTab
    }
    
    init() {
        UINavigationBar.appearance().shadowImage = UIImage(named: "navigationBorder")
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Prata-regular", size: 28)!, .foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Prata-regular", size: 20)!, .foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar.appearance().tintColor = .white
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorColor = UIColor.clear
    }
        
    var body: some View {
        NavigationView {
            VStack {
                if currentTab == 0 {
                    FavoritesView()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                        .navigationBarTitle("Favorites", displayMode: .inline)

                } else if currentTab == 1 {
                    RecommendationsView()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                        .navigationBarTitle("Recommendations", displayMode: .inline)
                } else if currentTab == 2 {
                    AboutView()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                        .navigationBarTitle("About YourFood", displayMode: .inline)
                }
                TabBar(parent: self)
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .background(Color("Charcoal").edgesIgnoringSafeArea(.all))
            
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

class KeyboardResponder: ObservableObject {
    let willset = PassthroughSubject<CGFloat, Never>()
    private var _center: NotificationCenter
    @Published var currentHeight: CGFloat = 0
    var keyboardDuration: TimeInterval = 0

    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        _center.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            guard let duration:TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            keyboardDuration = duration

            withAnimation(.easeInOut(duration: duration)) {
                self.currentHeight = keyboardSize.height
            }

        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        guard let duration:TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        withAnimation(.easeInOut(duration: duration)) {
            currentHeight = 0
        }
    }
}
