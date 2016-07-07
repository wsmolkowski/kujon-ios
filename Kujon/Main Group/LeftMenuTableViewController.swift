//
//  LeftMenuTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol LeftMenuTableViewControllerDelegate {
    func selectedMenuItem(menuController: LeftMenuTableViewController, menuItem: MenuItemWithController,withDelegate:Bool)

}

class LeftMenuTableViewController: UITableViewController {

    private let MenuItemCellIdentiefier = "menuUsosCell"

    var delegate: LeftMenuTableViewControllerDelegate?

    private var listOfUpperItems: Array<MenuItemWithController>!
    private var listOfLowerItems: Array<MenuItemWithController>!

    override func viewDidLoad() {
        super.viewDidLoad()

        listOfUpperItems = MenuItemsHolder.sharedInstance.upperMenuItems;
        listOfLowerItems = MenuItemsHolder.sharedInstance.lowerMnuItems;
        self.tableView.registerNib(UINib(nibName: "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier: MenuItemCellIdentiefier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return listOfUpperItems.count
        case 1: return listOfLowerItems.count
        default: return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MenuItemTableViewCell = tableView.dequeueReusableCellWithIdentifier(MenuItemCellIdentiefier, forIndexPath: indexPath) as! MenuItemTableViewCell
        var menuItem = self.getCurrentMenuItem(indexPath)
        dispatch_async(dispatch_get_main_queue()) {

            cell.imagePlace?.image = menuItem.returnImage()
        }
        cell.myLabel.text = menuItem.returnTitle()

        return cell
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var menuItem = self.getCurrentMenuItem(indexPath)
        if(menuItem.returnViewController()){
            self.delegate?.selectedMenuItem(self, menuItem: menuItem,withDelegate: indexPath.section==0 )
        }else{
            UIApplication.sharedApplication().openURL((menuItem as! MenuItemWithURL).returnURL()!)
        }
    }

    private func getCurrentMenuItem(indexPath: NSIndexPath)->MenuItemWithController{
        var list = indexPath.section==0 ? listOfUpperItems:listOfLowerItems
        return list[indexPath.row] as MenuItemWithController
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
