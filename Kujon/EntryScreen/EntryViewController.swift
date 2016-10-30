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

class EntryViewController: UIViewController,
        FBSDKLoginButtonDelegate,
        OnFacebookCredentailSaved,
        GIDSignInUIDelegate,
        GIDSignInDelegate,
        ConfigProviderDelegate,
        OpenLoginScreenProtocol,
        UsosesTableViewControllerDelegate,
        LogoutProviderDelegate{

    let googleSignInManager = GIDSignIn.sharedInstance()

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var googleLogInButton: GIDSignInButton!
    @IBOutlet weak var spinnerView: SpinnerView!
    let facebookManager = FacebookManager.sharedInstance
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    var configProvider = ProvidersProviderImpl.sharedInstance.provideConfigProvider()
    var socialLogin = true
    @IBOutlet weak var rejestrujacLabel: UILabel!
    private let logoutProvider = LogoutProvider()

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

        let fiveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.toggleAPIMode))
        fiveTapGestureRecognizer.numberOfTapsRequired = 5
        logoView.addGestureRecognizer(fiveTapGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.isUserInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)

        loginButton.tooltipColorStyle = .neutralGray

        logoutProvider.delegate = self

    }

    func toggleAPIMode(_ sender: UITapGestureRecognizer) {
        RestApiManager.toggleAPIMode()
        let message: String  = RestApiManager.APIMode == .production ? StringHolder.productionMode : StringHolder.demoMode
        ToastView.showInParent(self.navigationController?.view, withText: message, forDuration: 2.0)
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
        } else {
            presentAlertWithMessage("Wystąpił błąd podczas logowania przez serwis Facebook", title: "Błąd")
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
            let controller = UsosesTableViewController()
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    func pairedWithUsos() {
        spinnerView.isHidden = true
        self.present(ContainerViewController(), animated: true, completion: nil)
    
    }

    func notPairedWithUsos() {
        spinnerView.isHidden = true
        let controller = UsosesTableViewController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
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


    //MARK: UsosesTableViewControllerDelegate

    func usosesTableViewControllerDidTriggerLogout() {

        if GoogleManager.sharedInstance.getLoginType() == .google {
            GoogleManager.sharedInstance.logout(self)
        }

        if FacebookManager.sharedInstance.getLoginType() == .facebook {
            FacebookManager.sharedInstance.logout(self)
        }

        if EmailManager.sharedInstance.getLoginType() == .email {
            EmailManager.sharedInstance.logout(self)
        }

    }


    //MARK: LogoutProviderDelegate

    func onSuccesfullLogout() {
        // do nothing
    }

}

extension EntryViewController {

    override func succes() {
        // do nothing
    }

    override func failed(_ text: String) {
        // do nothing
    }
    
}
