//
//  RegisterViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 19/09/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,RegistrationProviderDelegate {

    @IBOutlet weak var seconPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private let checker = Checker()
    private let registerProvider = ProvidersProviderImpl.sharedInstance.provideRegistrationProvider()
    override func viewDidLoad() {

        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(RegisterViewController.back), andTitle: StringHolder.appName)
        self.edgesForExtendedLayout = UIRectEdge.None
        self.registerProvider.delegate = self;
    }
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onRegisterResponse(text: String) {
        let alertController = UIAlertController(title: StringHolder.attention, message: text, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            self.back()

        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    func onErrorOccurs(text: String) {
        showAlert(text)
    }

    @IBAction func onRegisterClick(sender: AnyObject) {
        let email = emailTextField.text!
        if(!checker.isEmail(email)){
           showAlert(StringHolder.emailPasswordError)
            return
        }
        let password = passwordTextField.text!
        if(!checker.arePasswordGoodRegex(password)){
            showAlert(StringHolder.passwordPasswordError)
            return
        }
        if(password != seconPasswordTextField.text){
            showAlert(StringHolder.identicalPasswordError)
            return
        }
        registerProvider.register(email, password: password)

    }


    private func showAlert(text: String){
        let alertController = UIAlertController(title: "Błąd rejestracji ", message: text, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)

        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
