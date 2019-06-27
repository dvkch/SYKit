//
//  AppDelegate.swift
//  SYKitExample
//
//  Created by Stanislas Chevallier on 26/06/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit
import  SYKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.mainWindow(rootViewController: ViewController())
        return true
    }
}

