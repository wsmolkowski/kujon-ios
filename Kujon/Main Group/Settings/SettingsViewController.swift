//
//  SettingsViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 10/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController,
        FBSDKLoginButtonDelegate,
        DeleteAccountProviderDelegate,
        GIDSignInUIDelegate {

    var loginMenager: UserLogin! = nil

    @IBOutlet weak var googleLogOutButton: UIButton!
    var deleteAccountProvider = ProvidersProviderImpl.sharedInstance.provideDeleteAccount()
    
    @IBOutlet weak var logOutButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SettingsViewController.back))
        self.edgesForExtendedLayout = UIRectEdge.None
        logOutButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        deleteAccountProvider.delegate = self
        loginMenager = UserLoginEnum.getUserLogin()
        switch (UserLoginEnum.getLoginType()) {
        case .FACEBOOK:
            googleLogOutButton.hidden  = true
            break
        case .GOOGLE:
            logOutButton.hidden  = true
            break
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func googleLogOutAction(sender: AnyObject) {
        loginMenager.logout()
        goBackToEntryScreen();

    }

    private func goBackToEntryScreen(){
        loginMenager.logout()
        let controller = EntryViewController()
        self.presentViewController(controller, animated: true, completion: nil)
    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func deleteAccount(sender: AnyObject) {
        showAlertApi(StringHolder.attention, text: StringHolder.deleteAccount, succes: {
            self.deleteAccountProvider.deleteAccount()
        }, cancel: {})
    }

    func accountDeleted() {
        UserDataHolder.sharedInstance.loggedToUsosForCurrentEmail = false
        goBackToEntryScreen();
    }

    func onErrorOccurs() {
    }


    @IBAction func regulaminAction(sender: AnyObject) {
        if let url = NSURL(string: StringHolder.kujonRegulaminUrl) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        goBackToEntryScreen();
    }


    func onErrorOccurs(text: String) {
    }


}
