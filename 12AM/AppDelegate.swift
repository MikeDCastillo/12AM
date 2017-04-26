//
//  AppDelegate.swift
//  12AM
//
//  Created by Michael Castillo on 4/9/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        let nc = UNUserNotificationCenter.current()
        nc.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let error = error {
                print("Error requesting authorization for notifications: \(error)")
                return
            }
        }
        TimeTracker.shared.startTimer()
        
        UIApplication.shared.registerForRemoteNotifications()
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 95/255, green: 95/255, blue: 90/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    
               let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    
        return handled
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PostController.sharedController.performFullSync()
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

