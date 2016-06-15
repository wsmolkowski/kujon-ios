//
//  SettingsViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 10/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class SettingsViewController: UIViewController,FBSDKLoginButtonDelegate {
    let userDataHolder = UserDataHolder.sharedInstance

    @IBOutlet weak var logoutButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self,selector: #selector(SettingsViewController.back))
        self.edgesForExtendedLayout = UIRectEdge.None
        logoutButton.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        userDataHolder.userEmail = nil
        userDataHolder.userToken = nil
        let controller  = EntryViewController()
        self.presentViewController(controller,animated:true,completion:nil)
    }


}
