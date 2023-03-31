//
//  SplashViewModal.swift
//  RickAndMortyWiki
//
//  Created by Harun on 31.03.2023.
//

import Foundation
import UIKit

class SplashViewModel {
    
    //It returns "Welcome" in first show after that "Hello"
    func getGreetingMessage() -> String {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "hasOpenedBefore") {
            defaults.set(true, forKey: "hasOpenedBefore")
            return "Welcome"
        } else {
            return "Hello"
        }
    }
    
    //Navigate to home screen after the time passed
    func showHomeScreen(_ nav : UINavigationController?,_ time : CGFloat){
        let homeViewController = HomeView()
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            nav?.setViewControllers([homeViewController], animated: true)
        }
    }
}
