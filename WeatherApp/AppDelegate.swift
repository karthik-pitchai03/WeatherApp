//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Apple on 17/10/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

        var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let vc = WeatherControlller()
        let root = UINavigationController(rootViewController: vc)
        root.navigationBar.isHidden = false
        window?.rootViewController?.navigationController?.isNavigationBarHidden = true
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
        return true
    }

}



