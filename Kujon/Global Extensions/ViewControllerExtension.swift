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
    
    func createLabelForSectionTitle(text: String,middle:Bool = false) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 48))
        view.backgroundColor = UIColor.greyBackgroundColor()
        let label = UILabel(frame: CGRectMake(11, 0, self.tableView.frame.size.width - 11, 48))
        let font = UIFont.kjnTextStyle2Font()
        label.font = font
        label.text = text
        if(middle){
            label.textAlignment = .Center
        }
        label.textColor = UIColor.blackWithAlpha()
        view.addSubview(label)
        view.layer.addBorder(UIRectEdge.Top,color:UIColor.lightGray(),thickness: 0.5)
        return view
    }


}
