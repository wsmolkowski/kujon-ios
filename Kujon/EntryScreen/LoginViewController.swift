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

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(RegisterViewController.back), andTitle: StringHolder.appName)
        self.edgesForExtendedLayout = UIRectEdge.None

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.showTerms))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rejestrujacLabel.userInteractionEnabled = true
        rejestrujacLabel.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onLoginResponse() {
    }

    func onErrorOccurs(text: String) {
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
    }


}
