//
//  AppDelegate.swift
//  AdvertisingPage
//
//  Created by Magic on 2018/2/24.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let rootVC = ZGADViewController.init(bottomSpace: 60, imageUrl: "http://pic.58pic.com/58pic/10/97/02/30a58PICH7N.jpg", localImage: "1.jpg") { [weak self](type) in
            print(">>>Type:\(type)---下一步处理")
            self?.window?.rootViewController = HomeViewController()
            self?.window?.makeKeyAndVisible()
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }


}

