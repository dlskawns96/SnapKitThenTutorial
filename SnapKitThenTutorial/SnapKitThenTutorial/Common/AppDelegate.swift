//
//  AppDelegate.swift
//  SnapKitThenTutorial
//
//  Created by Lee Nam Jun on 2021/06/01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds) // Screen 크기의 window 생성
        let homeViewController = ViewController()
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
        return true
    }
}

