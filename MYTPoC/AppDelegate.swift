//
//  AppDelegate.swift
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 murugananda. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCYjIf9f3YNeEaP-TOyv-wyGblh3yKmjwI")
        
        return true
    }
}

