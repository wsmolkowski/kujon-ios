//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController {

    var myPopUpView: UIView! = nil
    let animationDuration = 0.150

    override func viewDidLoad() {
        super.viewDidLoad()
        myPopUpView = setMyPopUpView();
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.myPopUpView.layer.cornerRadius = 12
        self.myPopUpView.layer.shadowOpacity = 0.8
        self.myPopUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopUpViewController.handleTap))
        self.view.addGestureRecognizer(tap)
    }

    func setMyPopUpView() -> UIView! {
        return nil
    }

    func handleTap() {
        removeAnimate()
    }


    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {
            (finished: Bool) in
        });
    }

    func removeAnimate() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: {
            (finished: Bool) in
            if (finished) {
                self.dismiss(animated: true, completion: nil)
            }
        });
    }

    func removeAnimate(_ funca: @escaping () -> Void) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: {
            (finished: Bool) in
            if (finished) {
                self.dismiss(animated: true, completion: nil)
                funca()
            }
        });
    }
}
