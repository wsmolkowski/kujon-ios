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

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate, OnFacebookCredentailSaved, GIDSignInUIDelegate {

    let googleSignInManager = GIDSignIn.sharedInstance()
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    let facebookManager = FacebookManager.sharedInstance
    @IBOutlet weak var loginButton: FBSDKLoginButton!

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

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(GoogleManager.sharedInstance.isLoggedIn()) {
            onFacebookCredentailSaved(GoogleManager.sharedInstance.isLoggedIn())
        }
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
        var controller: UIViewController!
        if (isLogged) {
            controller = ContainerViewController()
        } else {
            controller = UsosHolderController()
        }
        self.presentViewController(controller, animated: true, completion: nil)
    }

}