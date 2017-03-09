//
//  LoginViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 19/09/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,LoginProviderDelegate {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var rejestrujacLabel: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var spinner: SpinnerView!
    
    weak var delegete: UserLoginDelegate! = nil
    var loginProvider = ProvidersProviderImpl.sharedInstance.provideLoginProvider()
    let emailManager = EmailManager.sharedInstance
    var email:String = UserDataHolder.sharedInstance.userEmailRemembered ?? ""
    private let checker = Checker()

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(RegisterViewController.back), andTitle: StringHolder.loggin2)
        self.edgesForExtendedLayout = UIRectEdge()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.isUserInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)
        loginProvider.delegate = self
        emailLabel.text = email
        spinner.isHidden = true
    }

    func onLoginResponse(_ token: String) {
        spinner.isHidden = true
        let _ = navigationController?.popViewController(animated: true)
        UserDataHolder.sharedInstance.userEmailRemembered = email
        emailManager.login(email, token: token,listener: delegete)
    }

    func onErrorOccurs(_ text: String, retry: Bool) {
        spinner.isHidden = true
        if retry &&  passwordLabel.text != nil {
            loginProvider.login(email, password: passwordLabel.text!)
            spinner.isHidden = false
            return
        }
        showAlert(text)
    }

    func showTerms(_ sender: UITapGestureRecognizer){
        NSlogManager.showLog("showTermsAndConditions")
        var controller: UIViewController!
        controller = WebViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }

    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onLoginClick(_ sender: AnyObject) {
        email = emailLabel.text!
        if(!checker.isEmail(email)){
            showAlert(StringHolder.emailPasswordError)
            return
        }
        let password = passwordLabel.text!
        if(!checker.arePasswordGoodRegex(password)){
            showAlert(StringHolder.passwordPasswordError)
            return
        }
        loginProvider.delegate = self
        loginProvider.login(email, password: password)
        spinner.isHidden = false
    }

    private func showAlert(_ text: String){
        let alertController = UIAlertController(title: "Błąd Logowania ", message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)

        }))
        present(alertController, animated: true, completion: nil)
    }
}
