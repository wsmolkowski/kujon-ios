//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {

    func showAlertApiError(repeatFunction: ()->Void,cancel : ()->Void){
        let alertController = UIAlertController(title: "Uwaga", message: "Wystąpił błąd w komunikacji z serwerem. Czy chcesz powtórzyć?", preferredStyle: .Alert)

        alertController.addAction(UIAlertAction(title: "Tak", style: .Default, handler: { (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true,completion: nil)
            repeatFunction()

        }))
        alertController.addAction(UIAlertAction(title: "Nie", style: .Cancel, handler: { (action: UIAlertAction!) in
            alertController.dismissViewControllerAnimated(true,completion: nil)
            cancel()
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
