//
//  EntryViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate  {
    let userDataHolder = UserDataHolder.sharedInstance

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not loged in..")
        } else {
            print("Loged in...")
            self.loadFBParams2()
        }
        

        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
    
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openList(sender: AnyObject) {
        
        let controller  = UsosesTableViewController()
        self.presentViewController(controller,animated:true,completion:nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if error == nil
        {
            print("Load FB params on login success")
            self.loadFBParams2()

//            self.openList(nil)
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Loged out...")
    }
    
    func loadFBParams() {

        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["email", "public_profile"]){ result, error in
            print("RESULT: '\(result)' ")

            if error != nil {
                print("error")
            }else if(result.isCancelled){
                print("result cancelled")
            }else{
                print("success logInWithReadPermissions.")
                print("Now requesting user details")



                var fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "email"]);
                fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in

                    if error == nil {

                        print("User Info With Email : \(result)")
                    } else {

                        print("Error Getting Info \(error)");

                    }
                }
            }
        }
    }

    func loadFBParams2() {

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            let token: String = FBSDKAccessToken.currentAccessToken().tokenString;
            print( "Token : \(token) ")
            self.userDataHolder.userToken = token

        }

         FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, email"]).startWithCompletionHandler { (connection, result, error) -> Void in
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let email: String = (result.objectForKey("email") as? String)!
            self.userDataHolder.userEmail = email
            print( "Welcome, \(strFirstName) \(email)")
        }
    }

}
