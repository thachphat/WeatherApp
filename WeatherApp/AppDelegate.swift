//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: WeatherListViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
