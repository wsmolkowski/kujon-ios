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
        LogoutSucces,
        GIDSignInUIDelegate {

    var loginMenager: UserLogin! = nil

    @IBOutlet weak var googleLogOutButton: UIButton!
    var deleteAccountProvider = ProvidersProviderImpl.sharedInstance.provideDeleteAccount()

    @IBOutlet weak var logoutIcon: UIImageView!
    @IBOutlet weak var logOutButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SettingsViewController.back), andTitle: StringHolder.settings)
        self.edgesForExtendedLayout = UIRectEdge.None
        logOutButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        deleteAccountProvider.delegate = self
        loginMenager = UserLoginEnum.getUserLogin()
        logOutButton.hidden = true


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func googleLogOutAction(sender: AnyObject) {
        goBackToEntryScreen();

    }

    private func goBackToEntryScreen() {
        loginMenager.logout(self)

    }

    func succes() {
        let controller = EntryViewController()
        let  navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    func failed(text: String) {
        self.showAlertApiError({
            self.goBackToEntryScreen()
        }, cancelFucnt: {})
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




    @IBAction func regulaminAction(sender: AnyObject) {
        if let url = NSURL(string: StringHolder.kujonRegulaminUrl) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        goBackToEntryScreen();
    }

    func onSuccesfullLogout() {
    }

    func onErrorOccurs(text: String) {
    }


}
