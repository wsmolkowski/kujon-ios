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
    var deleteAccountProvider = ProvidersProviderImpl.sharedInstance.provideDeleteAccount()

    @IBOutlet weak var logoutIcon: UIImageView!
    @IBOutlet weak var logOutButton: FBSDKLoginButton!
    @IBOutlet weak var spinner: SpinnerView!




    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SettingsViewController.back), andTitle: StringHolder.settings)
        self.edgesForExtendedLayout = UIRectEdge()
        logOutButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        deleteAccountProvider.delegate = self
        loginMenager = UserLoginEnum.getUserLogin()
        logOutButton.isHidden = true
        spinner.isHidden = true
        view.backgroundColor = UIColor.greyBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func googleLogOutAction(_ sender: AnyObject) {
        self.spinner.isHidden = false
        goBackToEntryScreen();

    }

    private func goBackToEntryScreen() {
        loginMenager.logout(self)

    }

    override func succes() {
        let controller = EntryViewController()
        let  navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func failed(_ text: String) {
        self.showAlertApiError({
            self.goBackToEntryScreen()
        }, cancelFucnt: {})
    }


    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteAccount(_ sender: AnyObject) {
        showAlertApi(StringHolder.attention, text: StringHolder.deleteAccount, succes: {
            self.spinner.isHidden = false
            self.deleteAccountProvider.deleteAccount()

        }, cancel: {})
    }

    func accountDeleted() {
        UserDataHolder.sharedInstance.loggedToUsosForCurrentEmail = false
        self.spinner.isHidden = true
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
        self.spinner.isHidden = true
    }

    func onErrorOccurs(_ text: String) {
        self.spinner.isHidden = true
    }


}
