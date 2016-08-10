//
//  EntryViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate,
        OnFacebookCredentailSaved,
        GIDSignInUIDelegate,
        GIDSignInDelegate,
        ConfigProviderDelegate {

    let googleSignInManager = GIDSignIn.sharedInstance()


    let facebookManager = FacebookManager.sharedInstance
    @IBOutlet weak var loginButton: FBSDKLoginButton!


    var configProvider = ProvidersProviderImpl.sharedInstance.provideConfigProvider()
    var socialLogin = true

    @IBAction func showTermsAndConditions(sender: AnyObject) {
        NSlogManager.showLog("showTermsAndConditions")
        var controller: UIViewController!
        controller = WebViewController()
        let navigationController = UINavigationController(rootViewController: controller)

//        navigationController.navigationBar.barTintColor = UIColor.kujonBlueColor()
        self.presentViewController(navigationController, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        self.configProvider.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        if (GoogleManager.sharedInstance.isLoggedIn()) {
            self.configProvider.checkConfig()
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if error == nil {
            print("Load FB params on login success")
            facebookManager.loadFBParams(self)

//            self.openList(nil)
        } else {
            print(error.localizedDescription)
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
        facebookManager.logout()
    }


    func onFacebookCredentailSaved(isLogged: Bool) {
        socialLogin = true
        self.configProvider.checkConfig()

    }

    func notLogged() {
        if (socialLogin) {
            var controller: UIViewController!

            controller = UsosHolderController()

            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func pairedWithUsos() {
        self.presentViewController(ContainerViewController(), animated: true, completion: nil)
    }

    func notPairedWithUsos() {
        self.presentViewController(UsosHolderController(), animated: true, completion: nil)
    }

    func usosDown() {
        self.showAlertApi(StringHolder.attention, text: StringHolder.errorUsos, succes: {
            self.configProvider.checkConfig()
        }, cancel: {})
    }

    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: StringHolder.errorUsos, succes: {
            self.configProvider.checkConfig()
        }, cancel: {})
    }


    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            let googleManager = GoogleManager.sharedInstance
            googleManager.loadGoogleParams(self)


        } else {
            print("\(error.localizedDescription)")
        }
    }

}