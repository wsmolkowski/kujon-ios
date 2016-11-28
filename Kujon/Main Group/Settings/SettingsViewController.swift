//
//  SettingsViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 10/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController, DeleteAccountProviderDelegate, SettingsProviderDelegate {

    var loginMenager: UserLogin! = nil
    var deleteAccountProvider = ProvidersProviderImpl.sharedInstance.provideDeleteAccount()
    @IBOutlet weak var spinner: SpinnerView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var calendarSyncSwitch: UISwitch!
    let settingsProvider: SettingsProvider = SettingsProvider()
    let userData = UserDataHolder.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SettingsViewController.back), andTitle: StringHolder.settings)
        settingsProvider.delegate = self
        self.edgesForExtendedLayout = UIRectEdge()
        deleteAccountProvider.delegate = self
        spinner.isHidden = true
        view.backgroundColor = UIColor.greyBackgroundColor()
        updateNotificationsSwitchState()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        updateCalendarSyncSwitchState()
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


    internal func appDidBecomeActive() {
        let notificationsEnabled = NotificationsManager.pushNotificationsEnabled()
        updateNotificationsSwitchState()
        if userData.pushNotificationsEnabled != notificationsEnabled {
            userData.pushNotificationsEnabled = notificationsEnabled
            settingsProvider.setPushNotifications(enabled: notificationsEnabled)
            spinner.isHidden = false
        }
    }

    internal func pushNotificationsSettingDidSucceed() {
        spinner.isHidden = true
    }

    @IBAction func notificationsButtonDidTap(_ sender: UIButton) {
        presentAlertWithMessage(StringHolder.shouldOpenAppSettingsForNotifications, title: StringHolder.attention, addCancelAction: true) {
            NotificationsManager.openAppSettings()
        }
    }

    internal func updateNotificationsSwitchState() {
        let notificationsEnabled = NotificationsManager.pushNotificationsEnabled()
        notificationSwitch.setOn(notificationsEnabled, animated: true)
    }

    @IBAction func shareButtonDidTap(_ sender: UIButton) {
        let controller = UIActivityViewController(activityItems: [StringHolder.appItunesLink], applicationActivities: nil)
        if let actv = controller.popoverPresentationController {
            actv.sourceView = self.view;
        }
        self.present(controller, animated: true, completion: nil)
    }


    @IBAction func sendOpinionButtonDidTap(_ sender: UIButton) {
        let URLCharactersSet = NSCharacterSet.urlQueryAllowed
        let mailToURL = URL(string: "mailto:kujon@kujon.mobi?subject=Uwaga do Kujona".addingPercentEncoding(withAllowedCharacters: URLCharactersSet)!)!
        UIApplication.shared.openURL(mailToURL)
    }

    // MARK: Calendar Sync

    @IBAction func calendarSyncSwitchDidChange(_ sender: UISwitch) {
        spinner.isHidden = false
        settingsProvider.setCalendarSyncronization(enabled: sender.isOn)
    }

    func settingsDidLoad(_ settings: Settings) {
        updateCalendarSyncSwitchState()
    }

    func calendarSyncronizationSettingDidSucceed() {
        spinner.isHidden = true
    }

    func onErrorOccurs(_ text: String) {
        self.spinner.isHidden = true
        updateCalendarSyncSwitchState()
        updateNotificationsSwitchState()
        presentAlertWithMessage(text, title: StringHolder.errorAlertTitle)
    }

    func updateCalendarSyncSwitchState() {
        calendarSyncSwitch.isEnabled = UserLoginEnum.getLoginType() == .google
        calendarSyncSwitch.setOn(userData.shouldSyncCalendar, animated: true)
    }

}
