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
    var userDataHolder = UserDataHolder.sharedInstance


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        SessionManager.setCache()
        window = UIWindow(frame: UIScreen.main.bounds)

        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")

        let googleSignIn = GIDSignIn.sharedInstance()
        googleSignIn?.scopes.append("https://www.googleapis.com/auth/calendar")
        googleSignIn?.scopes.append("https://www.googleapis.com/auth/contacts")
        googleSignIn?.signInSilently()

        openControllerDependingOnLoginState()

        //TODO setup proper OneSignal app Id
        _ = OneSignal(launchOptions: launchOptions, appId: "f01a20f9-bbe7-4c89-a017-bf8930c61cf4", handleNotification: nil)

        OneSignal.defaultClient().enable(inAppAlertNotification: true)

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        // TODO make some better handling

        if url.absoluteString.contains("googleusercontent") {
            //let options: [String:AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication! as AnyObject, UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
            return GIDSignIn.sharedInstance().handle(url,
                    sourceApplication: sourceApplication,
                    annotation: annotation)
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)

    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func openControllerDependingOnLoginState() {
        let controller = EntryViewController()
        let navigationController = UINavigationController(rootViewController: controller)

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }


    func signIn(_ signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}
