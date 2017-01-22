//
//  AppDelegate.swift
//  Askio
//
//  Created by Eliasz Sawicki on 08/01/17.
//  Copyright © 2017 eliaszsawicki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainFlowController: MainFlowController!
    var rootNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        rootNavigationController = UINavigationController()
        mainFlowController = MainFlowController(navigationController: rootNavigationController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        mainFlowController.startFlow()
        askForNotificationsPermission()
        return true
    }
    
    private func askForNotificationsPermission() {
        let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
}


