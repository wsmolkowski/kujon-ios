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
        DeleteAccountProviderDelegate {

    var loginMenager: UserLogin! = nil
    var deleteAccountProvider = ProvidersProviderImpl.sharedInstance.provideDeleteAccount()
    @IBOutlet weak var spinner: SpinnerView!
    @IBOutlet weak var notificationSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SettingsViewController.back), andTitle: StringHolder.settings)
        self.edgesForExtendedLayout = UIRectEdge()
        deleteAccountProvider.delegate = self
        spinner.isHidden = true
        view.backgroundColor = UIColor.greyBackgroundColor()
        updateNotificationsState()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.updateNotificationsState), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func logoutButtonDidTap(_ sender: AnyObject) {
        self.spinner.isHidden = false
        logout();

    }

    private func logout() {
        loginMenager = UserLoginEnum.getUserLogin()
        loginMenager.logout(self)

    }

    override func succes() {
        let controller = EntryViewController()
        let  navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func failed(_ text: String) {
        self.showAlertApiError({ [weak self] in
            self?.logout()
        }, cancelFucnt: {})
    }


    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteAccountButtonDidTap(_ sender: AnyObject) {
        showAlertApi(StringHolder.attention, text: StringHolder.deleteAccount, succes: { [weak self] in
            self?.spinner.isHidden = false
            self?.deleteAccountProvider.deleteAccount()

        }, cancel: {})
    }

    func accountDeleted() {
        UserDataHolder.sharedInstance.loggedToUsosForCurrentEmail = false
        self.spinner.isHidden = true
        logout();
    }

    @IBAction func regulaminButtonDidTap(_ sender: AnyObject) {
        if let url = URL(string: StringHolder.kujonRegulaminUrl) {
            UIApplication.shared.openURL(url)
        }
    }

    func onSuccesfullLogout() {
        self.spinner.isHidden = true
    }

    func onErrorOccurs(_ text: String) {
        self.spinner.isHidden = true
    }

    // MARK: push notifications

    internal func updateNotificationsState() {
        let notificationsEnabled = NotificationsManager.pushNotificationsEnabled()
        notificationSwitch.setOn(notificationsEnabled, animated: true)
    }

    @IBAction func notificationsButtonDidTap(_ sender: UIButton) {
        presentAlertWithMessage(StringHolder.shouldOpenAppSettingsForNotifications, title: StringHolder.attention, addCancelAction: true) {
            NotificationsManager.openAppSettings()
        }
    }


}
