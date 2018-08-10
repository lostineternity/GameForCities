//
//  AppDelegate.swift
//  GameForCities
//
//  Created by Sokol Vadym on 16.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyAvTEmHWPsAy5mS3Yb177i-FugWhowY29s")
        
        _ = Repository.shared
        
        return true
    }

}

