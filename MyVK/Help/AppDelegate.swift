//
//  AppDelegate.swift
//  MyVK
//
//  Created by Минтимер Харасов on 25.12.2022.
//

import UIKit
import KeychainSwift
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var notFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: "not_first_lauch")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "not_first_lauch")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if !notFirstLaunch {
            KeychainSwift().delete("vk_access_token")
            KeychainSwift().delete("vk_user_id")
            notFirstLaunch = true
        }
        print(KeychainSwift().get("vk_access_token") ?? "no token yet")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

