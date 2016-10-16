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
        ConfigProviderDelegate,
        OpenLoginScreenProtocol{

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
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String:AnyObject]

        self.edgesForExtendedLayout = UIRectEdge()
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
            self.spinnerView.isHidden = true
        })

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.isUserInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)

        loginButton.tooltipColorStyle = .neutralGray

    }


    func showTerms(_ sender: UITapGestureRecognizer){
        NSlogManager.showLog("showTermsAndConditions")
        var controller: UIViewController!
        controller = WebViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)

    }
    @IBAction func registerClick(_ sender: AnyObject) {
        let controller = RegisterViewController()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func onLoginClick(_ sender: AnyObject) {
        let controller = LoginViewController()
        controller.delegeta = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
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

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
//        facebookManager.logout(LogoutSucces())
    }


    func onFacebookCredentailSaved(_ isLogged: Bool) {
        socialLogin = true
        spinnerView.isHidden = false
        self.configProvider.checkConfig()

    }

    func notLogged() {
        spinnerView.isHidden = true
        if (socialLogin) {
            var controller: UIViewController!

            controller = UsosHolderController()

            self.present(controller, animated: true, completion: nil)
        }
    }

    func pairedWithUsos() {
        spinnerView.isHidden = true
        self.present(ContainerViewController(), animated: true, completion: nil)
    }

    func notPairedWithUsos() {
        spinnerView.isHidden = true
        self.present(UsosHolderController(), animated: true, completion: nil)
    }

    func usosDown() {
        spinnerView.isHidden = true
        self.showAlertApi(StringHolder.attention, text: StringHolder.errorUsos, succes: {
            self.spinnerView.isHidden = false
            self.configProvider.checkConfig()
        }, cancel: {})
    }

    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.spinnerView.isHidden = true
        }, cancel: {
            self.spinnerView.isHidden = true
        })
    }


    override func unauthorized(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.spinnerView.isHidden = false
            self.configProvider.checkConfig()
        }, cancel: {
            self.spinnerView.isHidden = true
        },show: false)
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let googleManager = GoogleManager.sharedInstance
            googleManager.loadGoogleParams(self)


        } else {
            self.spinnerView.isHidden = true
            print("\(error.localizedDescription)")
        }
    }

    func openLoginScreenWithEmail(_ email: String) {
        let controller = LoginViewController()
        controller.delegeta = self
        controller.email = email
        self.navigationController?.pushViewController(controller, animated: true)
    }


}
