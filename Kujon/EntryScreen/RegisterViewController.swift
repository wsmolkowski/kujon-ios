//
//  RegisterViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 19/09/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegistrationProviderDelegate {

    @IBOutlet weak var rejestrujacLabel: UILabel!
    @IBOutlet weak var seconPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    fileprivate let checker = Checker()
    fileprivate let registerProvider = ProvidersProviderImpl.sharedInstance.provideRegistrationProvider()

    weak var delegate: OpenLoginScreenProtocol! = nil
    fileprivate var emailText=""
    override func viewDidLoad() {

        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(RegisterViewController.back), andTitle: StringHolder.appName)
        self.edgesForExtendedLayout = UIRectEdge()
        self.registerProvider.delegate = self;

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.isUserInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    func showTerms(_ sender: UITapGestureRecognizer) {
        NSlogManager.showLog("showTermsAndConditions")
        var controller: UIViewController!
        controller = WebViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)

    }

    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onRegisterResponse(_ text: String) {
        let alertController = UIAlertController(title: StringHolder.attention, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            self.back()
            if(self.delegate != nil){
                self.delegate.openLoginScreenWithEmail(self.emailText)
            }

        }))
        present(alertController, animated: true, completion: nil)
    }

    func onErrorOccurs(_ text: String) {
        showAlert(text)
    }

    @IBAction func onRegisterClick(_ sender: AnyObject) {
        let email = emailTextField.text!
        if (!checker.isEmail(email)) {
            showAlert(StringHolder.emailPasswordError)
            return
        }
        let password = passwordTextField.text!
        if (!checker.arePasswordGoodRegex(password)) {
            showAlert(StringHolder.passwordPasswordError)
            return
        }
        if (password != seconPasswordTextField.text) {
            showAlert(StringHolder.identicalPasswordError)
            return
        }
        self.emailText = email;
        registerProvider.register(email, password: password)

    }


    fileprivate func showAlert(_ text: String) {
        let alertController = UIAlertController(title: "Błąd rejestracji ", message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)

        }))
        present(alertController, animated: true, completion: nil)
    }
}
