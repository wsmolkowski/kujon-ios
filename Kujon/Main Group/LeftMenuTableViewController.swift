//
//  LeftMenuTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol LeftMenuTableViewControllerDelegate {
    func selectedMenuItem(menuController: LeftMenuTableViewController, menuItem: MenuItemWithController, withDelegate: Bool)

}

class LeftMenuTableViewController: UITableViewController {

    private let MenuItemCellIdentiefier = "menuUsosCell"
    private let MenuItemHeaderIdentiefier = "menuItemHeader"
    private let userDataHolder = UserDataHolder.sharedInstance
    var delegate: LeftMenuTableViewControllerDelegate?

    private var listOfUpperItems: Array<MenuItemWithController>!
    private var listOfLowerItems: Array<MenuItemWithController>!

    override func viewDidLoad() {
        super.viewDidLoad()

        listOfUpperItems = MenuItemsHolder.sharedInstance.upperMenuItems;
        listOfLowerItems = MenuItemsHolder.sharedInstance.lowerMnuItems;
        self.tableView.registerNib(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: MenuItemCellIdentiefier)
        self.tableView.registerNib(UINib(nibName: "NavDrawerHeaderViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: MenuItemHeaderIdentiefier)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        self.view.backgroundColor = UIColor.greyBackgroundColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return listOfUpperItems.count
        case 2: return listOfLowerItems.count
        default: return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell: NavDrawerHeaderViewCellTableViewCell = tableView.dequeueReusableCellWithIdentifier(MenuItemHeaderIdentiefier, forIndexPath: indexPath) as! NavDrawerHeaderViewCellTableViewCell
            cell.userEmailLabel.text = self.userDataHolder.userEmail
            cell.userNameLabel.text = self.userDataHolder.userName
            if(self.userDataHolder.userImage != nil){

                cell.userImageView.image = self.userDataHolder.userImage
            }
            cell.userImageView.makeMyselfCircle()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {

            let cell: MenuItemTableViewCell = tableView.dequeueReusableCellWithIdentifier(MenuItemCellIdentiefier, forIndexPath: indexPath) as! MenuItemTableViewCell
            let menuItem = self.getCurrentMenuItem(indexPath)
            cell.myImage?.image = menuItem.returnImage()
            cell.myText.text = menuItem.returnTitle()
            cell.myText.font = UIFont.kjnTextStyle5Font()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }

    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 145
        case 1: return 48
        case 2: return 48
        default: return 0
        }
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section > 0) {

            let menuItem = self.getCurrentMenuItem(indexPath)
            if (menuItem.returnViewController()) {
                self.delegate?.selectedMenuItem(self, menuItem: menuItem, withDelegate: indexPath.section == 1)
            } else {
                if let url = (menuItem as! MenuItemWithURL).returnURL(){

                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }

    private func getCurrentMenuItem(indexPath: NSIndexPath) -> MenuItemWithController {
        var list = indexPath.section - 1 == 0 ? listOfUpperItems : listOfLowerItems
        return list[indexPath.row] as MenuItemWithController
    }


    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 1

        } else {
            return 0
        }
    }

}
