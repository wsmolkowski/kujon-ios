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

    weak var delegeta: OnFacebookCredentailSaved! = nil
    var loginProvider = ProvidersProviderImpl.sharedInstance.provideLoginProvider()
    let emailManager = EmailManager.sharedInstance
    var email:String = ""
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onLoginResponse(_ token: String) {
        self.back()
        emailManager.login(email, token: token,listener: delegeta)
    }


    func onErrorOccurs(_ text: String) {
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
        loginProvider.login(email, password: password)
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
