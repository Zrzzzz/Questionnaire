//
//  AppDelegate.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let viewController = QuerEditViewController()
        
        let navigationViewController = UINavigationController.init(rootViewController: viewController)
        
        self.window?.backgroundColor = UIColor.white
        
        self.window?.rootViewController = navigationViewController;
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        return true
    }
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
  


}
