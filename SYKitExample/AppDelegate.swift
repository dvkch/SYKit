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
        if #available(iOS 13.0, tvOS 13.0, *) {
            window = UIWindow.mainWindow(windowScene: nil, rootViewController: ViewController())
        }
        else {
            window = UIWindow.mainWindow(rootViewController: ViewController())
        }
        return true
    }
}

