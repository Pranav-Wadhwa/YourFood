//
//  SceneDelegate.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/23/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var onboardObserver: NSKeyValueObservation?
    
    func deinitOnboardObserver() {
        onboardObserver?.invalidate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    }
    
    func initOnboardObserver() {
        guard let window = window else { return }
        onboardObserver = UserDefaults.standard.observe(\.hasOnboarded, options: [.initial, .new], changeHandler: { (defaults, change) in
            if !UserDefaults.standard.hasOnboarded {
                return
            }
            let newVC = UIHostingController(rootView: HomeView())
            window.rootViewController = newVC
            
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {}, completion:
            { completed in
                // maybe do something on completion here
                self.deinitOnboardObserver()
            })
        })
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
         //.environment(\.managedObjectContext, context)
        
//        UserDefaults.standard.set(false, forKey: "hasOnboarded")
        
        let hasOnboarded = UserDefaults.standard.hasOnboarded

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            if !hasOnboarded {
                let onboardingController = UIHostingController(rootView: OnboardingView())
                window.rootViewController = onboardingController
            } else {
                let homeController = UIHostingController(rootView: HomeView().environment(\.managedObjectContext, context))
                window.rootViewController = homeController
            }
            
            self.window = window
            window.makeKeyAndVisible()
            if !hasOnboarded {
                initOnboardObserver()
            }
            
//            let locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.requestLocation()
            
            

        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        deinitOnboardObserver()
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if !UserDefaults.standard.hasOnboarded {
            initOnboardObserver()
        }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        deinitOnboardObserver()
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if !UserDefaults.standard.hasOnboarded {
            initOnboardObserver()
        }
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        deinitOnboardObserver()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

