//
//  UserViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,NavigationDelegate {

    weak var delegate: NavigationMenuProtocol!=nil

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate=delegate
    }

    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var studentStatusLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var indexNumberLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserViewController.openDrawer))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
