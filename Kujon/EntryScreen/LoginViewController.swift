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

    var delegeta: OnFacebookCredentailSaved! = nil
    var loginProvider = ProvidersProviderImpl.sharedInstance.provideLoginProvider()
    let emailManager = EmailManager.sharedInstance
    var email:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(RegisterViewController.back), andTitle: StringHolder.appName)
        self.edgesForExtendedLayout = UIRectEdge.None

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.userInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)
        loginProvider.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onLoginResponse(token: String) {
        self.back()
        emailManager.login(email, token: token)
    }


    func onErrorOccurs(text: String) {
        showAlert(text)
    }


    func showTerms(sender: UITapGestureRecognizer){
        NSlogManager.showLog("showTermsAndConditions")
        var controller: UIViewController!
        controller = WebViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)

    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onLoginClick(sender: AnyObject) {
        email = emailTextField.text!
        if(!checker.isEmail(email)){
            showAlert(StringHolder.emailPasswordError)
            return
        }
        let password = passwordTextField.text!
        if(!checker.arePasswordGoodRegex(password)){
            showAlert(StringHolder.passwordPasswordError)
            return
        }
        loginProvider.login(email, password: password)
    }



    private func showAlert(text: String){
        let alertController = UIAlertController(title: "Błąd Logowania ", message: text, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)

        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
