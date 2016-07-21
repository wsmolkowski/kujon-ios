//
//  AppDelegate.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright (c) 2016 Mobi. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var userDataHolder  = UserDataHolder.sharedInstance



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        SessionManager.setCache()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var value = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        var controller:UIViewController! = nil
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            controller = EntryViewController()
        } else {
            if(userDataHolder.loggedToUsosForCurrentEmail){
                controller = ContainerViewController()
            }else{
                controller =  UsosHolderController()
            }
        }


        window!.rootViewController = controller
        window!.makeKeyAndVisible()
        //TODO setup proper OneSignal app Id
        _ = OneSignal(launchOptions: launchOptions, appId: "b2f7f966-d8cc-11e4-bed1-df8f05be55ba", handleNotification: nil)
        
        OneSignal.defaultClient().enableInAppAlertNotification(true)
        
    return value
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }


    func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }


    func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


    func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }




}
