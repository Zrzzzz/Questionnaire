//
//  AppDelegate.swift
//  Questionnaire
//
//  Created by Zr埋 on 2020/4/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Unrealm


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        self.regeisterRealmObject() // 注册Realm类
        
        let viewController = HomeViewController()
        
        let navigationViewController = UINavigationController.init(rootViewController: viewController)
        
        self.window?.backgroundColor = UIColor.white
        UIApplication.statusBarBackgroundColor = TColor.main // 设置状态栏颜色
        self.window?.rootViewController = navigationViewController
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        return true
    }
    
    fileprivate func regeisterRealmObject() {
        Realm.registerRealmables([
            Paper.self,
            PaperQuestion.self,
            Blank.self,
            Multiple.self,
            Single.self
        ])
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

