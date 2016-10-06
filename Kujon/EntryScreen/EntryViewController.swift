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
import Crashlytics

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate,
        OnFacebookCredentailSaved,
        GIDSignInUIDelegate,
        GIDSignInDelegate,
        ConfigProviderDelegate {

    let googleSignInManager = GIDSignIn.sharedInstance()

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var googleLogInButton: GIDSignInButton!
    @IBOutlet weak var spinnerView: SpinnerView!

    let facebookManager = FacebookManager.sharedInstance
    @IBOutlet weak var loginButton: FBSDKLoginButton!


    var configProvider = ProvidersProviderImpl.sharedInstance.provideConfigProvider()
    var socialLogin = true


    @IBOutlet weak var rejestrujacLabel: UILabel!

    override func viewDidLoad() {


        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String:AnyObject]

        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Kujon"
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        self.configProvider.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

        GoogleManager.sharedInstance.isLoggedIn({
            self.configProvider.checkConfig()
        },googleComplete: {
            GIDSignIn.sharedInstance().signInSilently()
        } , noLogged: {
            self.spinnerView.hidden = true
        })

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.userInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)

        loginButton.tooltipColorStyle = .NeutralGray

    }


    func showTerms(sender: UITapGestureRecognizer){
        NSlogManager.showLog("showTermsAndConditions")
        var controller: UIViewController!
        controller = WebViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)

    }
    @IBAction func registerClick(sender: AnyObject) {
        let controller = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func onLoginClick(sender: AnyObject) {
        let controller = LoginViewController()
        controller.delegeta = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            if(result != nil && !result!.isCancelled){
                print("Load FB params on login success")
                facebookManager.loadFBParams(self)
            }


//            self.openList(nil)
        } else {
            print(error.localizedDescription)
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
//        facebookManager.logout(LogoutSucces())
    }


    func onFacebookCredentailSaved(isLogged: Bool) {
        socialLogin = true
        spinnerView.hidden = false
        self.configProvider.checkConfig()

    }

    func notLogged() {
        spinnerView.hidden = true
        if (socialLogin) {
            var controller: UIViewController!

            controller = UsosHolderController()

            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func pairedWithUsos() {
        spinnerView.hidden = true
        self.presentViewController(ContainerViewController(), animated: true, completion: nil)
    }

    func notPairedWithUsos() {
        spinnerView.hidden = true
        self.presentViewController(UsosHolderController(), animated: true, completion: nil)
    }

    func usosDown() {
        spinnerView.hidden = true
        self.showAlertApi(StringHolder.attention, text: StringHolder.errorUsos, succes: {
            self.spinnerView.hidden = false
            self.configProvider.checkConfig()
        }, cancel: {})
    }

    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.spinnerView.hidden = true
        }, cancel: {
            self.spinnerView.hidden = true
        })
    }


    override func unauthorized(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.spinnerView.hidden = false
            self.configProvider.checkConfig()
        }, cancel: {
            self.spinnerView.hidden = true
        },show: false)
    }


    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            let googleManager = GoogleManager.sharedInstance
            googleManager.loadGoogleParams(self)


        } else {
            self.spinnerView.hidden = true
            print("\(error.localizedDescription)")
        }
    }

}