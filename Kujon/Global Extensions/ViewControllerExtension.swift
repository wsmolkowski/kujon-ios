//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlertApiError(repeatFunction: () -> Void, cancelFucnt: () -> Void) {

        showAlertApi("Uwaga", text: "Wystąpił błąd w komunikacji z serwerem.", succes: repeatFunction, cancel: cancelFucnt)
    }


    func showAlertApi(title: String, text: String, succes: () -> Void, cancel: () -> Void, show:Bool = true) {
        let text2 = show ? text + " Czy chcesz spróbować ponownie ?": text;
        let alertController = UIAlertController(title: title, message: text2, preferredStyle: .Alert)
        if(show){
            alertController.addAction(UIAlertAction(title: "Tak", style: .Default, handler: {
                (action: UIAlertAction!) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
                succes()

            }))
            alertController.addAction(UIAlertAction(title: "Nie", style: .Cancel, handler: {
                (action: UIAlertAction!) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
                cancel()
            }))
        }else{
            alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {
                (action: UIAlertAction!) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
                cancel()
            }))
        }

        presentViewController(alertController, animated: true, completion: nil)
    }

    func openUrlString(text: String) {
        if let url = NSURL(string: text) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

extension UITableViewController {

    func createLabelForSectionTitle(text: String, middle: Bool = false, height: CGFloat = 48) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, height))
        view.backgroundColor = UIColor.greyBackgroundColor()
        let label = UILabel(frame: CGRectMake(11, 0, self.tableView.frame.size.width - 11, height))
        let font = UIFont.kjnTextStyle2Font()
        label.font = font
        label.text = text
        if (middle) {
            label.textAlignment = .Center
        }
        label.textColor = UIColor.blackWithAlpha()
        view.addSubview(label)
        view.layer.addBorder(UIRectEdge.Top, color: UIColor.lightGray(), thickness: 1)
        return view
    }


    func createTopBorder(tableViewCell: UITableViewCell){
        tableViewCell.layer.addBorder(UIRectEdge.Bottom,color:UIColor.lightGray(),thickness: 1)
    }


}

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}

extension UIViewController:Unauthorized{

    func unauthorized(text: String) {
        let alertController = UIAlertController(title: StringHolder.autorizationError , message: text, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Tak", style: .Default, handler: {
            (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            let controller  = EntryViewController(nibName: "EntryViewController", bundle: nil)
            UserDataHolder.sharedInstance.userEmail = nil
            UserDataHolder.sharedInstance.userToken = nil
            UserDataHolder.sharedInstance.userImage = nil
            UserDataHolder.sharedInstance.userName = nil
            self.presentViewController(controller, animated: true, completion: nil)
        }))
    }

}