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


    func showAlertApi(title: String, text: String, succes: () -> Void, cancel: () -> Void) {
        let alertController = UIAlertController(title: title, message: text + ". Czy chcesz spróbować ponownie ?", preferredStyle: .Alert)

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
        presentViewController(alertController, animated: true, completion: nil)
    }
}
extension UITableViewController {
    
    func createLabelForSectionTitle(text: String) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 56))
        let label = UILabel(frame: CGRectMake(8, 0, self.tableView.frame.size.width - 8, 48))
        label.font = label.font.fontWithSize(14)
        label.text = text
        label.textColor = UIColor.blackWithAlpha()
        view.addSubview(label)
        return view
    }
}
