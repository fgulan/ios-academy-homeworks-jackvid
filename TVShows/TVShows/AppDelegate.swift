//
//  AppDelegate.swift
//  TVShows
//
//  Created by Infinum Student Academy on 05/07/2018.
//  Copyright © 2018 Jakov Vidak. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SVProgressHUD.setDefaultMaskType(.black)
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.uicolorFromHex(rgbValue: 0xFF758C)
        navigationBarAppearace.barTintColor = UIColor.uicolorFromHex(rgbValue: 0xffffff)

        return true
    }
    
}

extension UIColor {
    
    static func uicolorFromHex(rgbValue:UInt32) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}

