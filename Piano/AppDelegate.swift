//
//  AppDelegate.swift
//  Piano
//
//  Created by Ibram Uppal on 11/2/15.
//  Copyright © 2015 Ibram Uppal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    private func application(application: UIApplication,
                             didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        VMPianoModel.shared.stopPlaying()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        VMPianoModel.shared.stopPlaying()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        VMPianoModel.shared.stopPlaying()
    }

}

