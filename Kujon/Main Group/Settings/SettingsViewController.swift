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
    let faceBookManager = FacebookManager.sharedInstance

 
    @IBOutlet weak var logOutButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self,selector: #selector(SettingsViewController.back))
        self.edgesForExtendedLayout = UIRectEdge.None
        logOutButton.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func deleteAccount(sender: AnyObject) {
    }
   
    @IBAction func regulaminAction(sender: AnyObject) {
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        faceBookManager.logout()
        let controller  = EntryViewController()
        self.presentViewController(controller,animated:true,completion:nil)
    }


}
