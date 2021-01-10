//
//  PageViewController.swift
//  RestaurantApp
//
//  Created by Pranav Wadhwa on 1/23/20.
//  Copyright © 2020 Pranav Wadhwa. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI

struct PageViewController: UIViewControllerRepresentable {
    
    var viewControllers: [UIViewController]
    var currentIndex: Int = -1
    var handler: OnboardingHandler?
    
    func makeCoordinator() -> PageViewController.Coordinator {
        return Coordinator(self)
    }
    
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageController.dataSource = context.coordinator
        pageController.delegate = context.coordinator

        return pageController
        
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: UIViewControllerRepresentableContext<PageViewController>) {
        uiViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
        
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var handler: OnboardingHandler?
        var parent: PageViewController
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
        {
            
            if (!completed) {
                return
            }
            self.parent.currentIndex = self.parent.viewControllers.firstIndex(of: pageViewController.viewControllers!.first!) ?? -1
            let subVC = pageViewController.viewControllers!.first! as! UIHostingController<OnboardingSubview>
            
            let vc = subVC.parent!.parent! as! UIHostingController<OnboardingView>
            vc.rootView.onboardPageChanged(newIndex: self.parent.currentIndex)
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                 return nil
             }
            
            if index == 0 {
                return nil
            }
            
            return parent.viewControllers[index - 1]
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.viewControllers.count {
                return nil
            }
            return parent.viewControllers[index + 1]
        }
        
        init(_ pageViewControler: PageViewController) {
            self.parent = pageViewControler
        }
    }
    
    
}

protocol OnboardingHandler {
    func onboardPageChanged(newIndex: Int)
}
