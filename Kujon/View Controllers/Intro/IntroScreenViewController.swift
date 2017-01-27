//
//  IntroScreenViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 18/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class IntroScreenViewController: UIViewController {
    let userDataHolder = UserDataHolder.sharedInstance
    @IBOutlet weak var uniLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(IntroScreenViewController.back),andTitle: StringHolder.loggin)
        uniLabel.text = StringHolder.usosGreetings + userDataHolder.usosName
    }

    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onContinueClick(_ sender: AnyObject) {
        self.back()
    }


}
