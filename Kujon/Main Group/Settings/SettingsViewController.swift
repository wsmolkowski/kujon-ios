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
        self.edgesForExtendedLayout = UIRectEdge()
        logOutButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        deleteAccountProvider.delegate = self
        loginMenager = UserLoginEnum.getUserLogin()
        logOutButton.isHidden = true


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func googleLogOutAction(_ sender: AnyObject) {
        goBackToEntryScreen();

    }

    fileprivate func goBackToEntryScreen() {
        loginMenager.logout(self)

    }

    func succes() {
        let controller = EntryViewController()
        let  navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }

    func failed(_ text: String) {
        self.showAlertApiError({
            self.goBackToEntryScreen()
        }, cancelFucnt: {})
    }


    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteAccount(_ sender: AnyObject) {
        showAlertApi(StringHolder.attention, text: StringHolder.deleteAccount, succes: {
            self.deleteAccountProvider.deleteAccount()
        }, cancel: {})
    }

    func accountDeleted() {
        UserDataHolder.sharedInstance.loggedToUsosForCurrentEmail = false

        goBackToEntryScreen();
    }




    @IBAction func regulaminAction(_ sender: AnyObject) {
        if let url = URL(string: StringHolder.kujonRegulaminUrl) {
            UIApplication.shared.openURL(url)
        }
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        goBackToEntryScreen();
    }

    func onSuccesfullLogout() {
    }

    func onErrorOccurs(_ text: String) {
    }


}
