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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        SessionManager.setCache()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let value = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")

        let googleSignIn = GIDSignIn.sharedInstance()
        var currentScopes = googleSignIn.scopes
        currentScopes.append("https://www.googleapis.com/auth/calendar")
        currentScopes.append("https://www.googleapis.com/auth/contacts")
        googleSignIn.scopes = currentScopes
        googleSignIn.signInSilently()

        openControllerDependingOnLoginState()

        //TODO setup proper OneSignal app Id
        _ = OneSignal(launchOptions: launchOptions, appId: "f01a20f9-bbe7-4c89-a017-bf8930c61cf4", handleNotification: nil)

        OneSignal.defaultClient().enableInAppAlertNotification(true)



        return value
    }
    //TODO: add safety checks
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        // TODO make some better handling
        let urlString: String = url.absoluteString!
        if (urlString.containsString("googleusercontent")) {
            let options: [String:AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                               UIApplicationOpenURLOptionsAnnotationKey: annotation]
            return GIDSignIn.sharedInstance().handleURL(url,
                    sourceApplication: sourceApplication,
                    annotation: annotation)
        }


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
        FBSDKAppEvents.activateApp()
    }


    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func openControllerDependingOnLoginState() {
        let controller = EntryViewController()
        let navigationController = UINavigationController(rootViewController: controller)

        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }


    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}
