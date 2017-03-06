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

    @IBOutlet weak var gradeNotificationsSwitch: UISwitch!
    @IBOutlet weak var hiddenGradeNotificationsButton: UIButton!

    @IBOutlet weak var fileNotificationsSwitch: UISwitch!
    @IBOutlet weak var hiddenFileNotificationsButton: UIButton!


    @IBOutlet weak var calendarSyncSwitch: UISwitch!
    @IBOutlet weak var appVersionLabel: UILabel!

    let settingsProvider: SettingsProvider = SettingsProvider()
    let userData = UserDataHolder.sharedInstance
    private var systemPushNotificationsEnabledOnViewLoad: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SettingsViewController.back), andTitle: StringHolder.settings)
        settingsProvider.delegate = self
        self.edgesForExtendedLayout = UIRectEdge()
        deleteAccountProvider.delegate = self
        spinner.isHidden = true
        view.backgroundColor = UIColor.greyBackgroundColor()
        gradeNotificationsSwitch.onTintColor = UIColor.kujonBlueColor()
        fileNotificationsSwitch.onTintColor = UIColor.kujonBlueColor()
        setupNotificationSwitches()
        calendarSyncSwitch.onTintColor = UIColor.kujonBlueColor()
        updateNotificationSwitchesState()
        appVersionLabel.text = Constants.appVersion
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        updateCalendarSyncSwitchState()
        settingsProvider.loadSettings()
        self.spinner.isHidden = false
        systemPushNotificationsEnabledOnViewLoad = NotificationsManager.systemPushNotificationsEnabled()

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
        showAlertApi(StringHolder.attention, text: StringHolder.deleteAccount, addRetryQuestion:false, actionButtonStyle: .destructive, succes: { [weak self] in
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


    // MARK: Grade Notifications

    private func setupNotificationSwitches() {
        let systemPushNotificationsEnabled = NotificationsManager.systemPushNotificationsEnabled()
        gradeNotificationsSwitch.isEnabled = systemPushNotificationsEnabled
        hiddenGradeNotificationsButton.isHidden = systemPushNotificationsEnabled
        fileNotificationsSwitch.isEnabled = systemPushNotificationsEnabled
        hiddenFileNotificationsButton.isHidden = systemPushNotificationsEnabled
    }

    internal func appDidBecomeActive() {
        let notificationsEnabled = NotificationsManager.systemPushNotificationsEnabled()
        if notificationsEnabled != systemPushNotificationsEnabledOnViewLoad {
            setupNotificationSwitches()
            updateNotificationSwitchesState()
            settingsProvider.setOneSignalGradeNotifications(enabled: notificationsEnabled)
            settingsProvider.setOneSignalFileNotifications(enabled: notificationsEnabled)
            spinner.isHidden = false
        }
    }

    internal func oneSignalNotificationsSettingDidSucceed() {
        spinner.isHidden = true
        updateNotificationSwitchesState()
    }

    @IBAction func gradeNotificationsSwitchDidChange(_ sender: UISwitch) {
        settingsProvider.setOneSignalGradeNotifications(enabled: sender.isOn)
        spinner.isHidden = false
    }

    @IBAction func gradeNotificationsButtonDidTap(_ sender: UIButton) {
        presentAlertWithMessage(StringHolder.shouldOpenAppSettingsForNotifications, title: StringHolder.attention, showCancelButton: true) {
            NotificationsManager.openAppSettings()
        }
    }

    internal func updateNotificationSwitchesState() {
        let gradeNotificationsEnabled = NotificationsManager.systemPushNotificationsEnabled() && userData.oneSignalGradeNotificationsEnabled
        gradeNotificationsSwitch.setOn(gradeNotificationsEnabled, animated: true)
        let fileNotificationsEnabled = NotificationsManager.systemPushNotificationsEnabled() && userData.oneSignalFileNotificationsEnabled
        fileNotificationsSwitch.setOn(fileNotificationsEnabled, animated: true)
    }

    // MARK: File Notifications

    @IBAction func fileNotificationsSwitchDidChange(_ sender: UISwitch) {
        settingsProvider.setOneSignalFileNotifications(enabled: sender.isOn)
        spinner.isHidden = false
    }

    @IBAction func fileNotificationsButtonDidTap(_ sender: UIButton) {
        presentAlertWithMessage(StringHolder.shouldOpenAppSettingsForNotifications, title: StringHolder.attention, showCancelButton: true) {
            NotificationsManager.openAppSettings()
        }
    }


    // MARK: Calendar Sync

    @IBAction func calendarSyncSwitchDidChange(_ sender: UISwitch) {
        spinner.isHidden = false
        settingsProvider.setCalendarSyncronization(enabled: sender.isOn)
    }

    func settingsDidLoad(_ settings: Settings) {
        updateCalendarSyncSwitchState()
        updateNotificationSwitchesState()
        self.spinner.isHidden = true
    }

    func calendarSyncronizationSettingDidSucceed() {
        spinner.isHidden = true
        updateCalendarSyncSwitchState()
    }

    func onErrorOccurs(_ text: String) {
        self.spinner.isHidden = true

        updateCalendarSyncSwitchState()
        updateNotificationSwitchesState()
        presentAlertWithMessage(text, title: StringHolder.errorAlertTitle)
    }

    func onUsosDown() {
        self.spinner.isHidden = true
        EmptyStateView.showUsosDownAlert(inParent: view)
    }

    func updateCalendarSyncSwitchState() {
        calendarSyncSwitch.isEnabled = UserLoginEnum.getLoginType() == .google
        calendarSyncSwitch.setOn(userData.shouldSyncCalendar, animated: true)
    }

}
