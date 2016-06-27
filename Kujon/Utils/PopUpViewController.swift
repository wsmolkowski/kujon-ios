//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController {

    var myPopUpView: UIView! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        myPopUpView = setMyPopUpView();
        self.myPopUpView.layer.cornerRadius = 5
        self.myPopUpView.layer.shadowOpacity = 0.8
        self.myPopUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopUpViewController.handleTap))
    }

    func setMyPopUpView() -> UIView! {
        return nil
    }

    func handleTap() {
        removeAnimate()
    }


    func showAnimate() {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }

    func removeAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
        }, completion: {
            (finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
    }
}
