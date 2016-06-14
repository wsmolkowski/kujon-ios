//
//  UserViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, NavigationDelegate, UserDetailsProviderDelegate ,DoOnStudentProgrammeClick{

    weak var delegate: NavigationMenuProtocol! = nil

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameSurnameLabel: UILabel!
  
    @IBOutlet weak var studentStatusLabel: UILabel!

    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var indexNumberLabel: UILabel!

    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var profileTableView: IntrinsicTableView!
    
    let userDetailsProvider: UserDetailsProvider!=UserDetailsProvider.sharedInstance
    let programmeController  = StudentProgrammeTableViewDelegateController()

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(UserViewController.openDrawer))
        programmeController.setUp(profileTableView,clickListener:self)

        userDetailsProvider.delegate = self
        userDetailsProvider.loadUserDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onUserDetailLoaded(userDetails: UserDetail) {
        nameSurnameLabel.text = userDetails.firstName + " " + userDetails.lastName
        studentStatusLabel.text = userDetails.studentStatus
        schoolNameLabel.text = userDetails.usosName
        indexNumberLabel.text = userDetails.studentNumber
        accountNumberLabel.text = userDetails.id
        if(userDetails.hasPhoto){
            dispatch_async(dispatch_get_main_queue()) {
                self.userImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string:userDetails.photoUrl)!)!)
            }
        }
        programmeController.setUpData(userDetails.studentProgrammes)
    }

    func onErrorOccurs() {
    }

    func doOnClick(programme: StudentProgramme) {
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
