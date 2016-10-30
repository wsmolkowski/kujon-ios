//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func presentAlertWithMessage(_ message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        parent?.present(alert, animated: true, completion: nil)
    }

    func showAlertApiError(_ repeatFunction: @escaping () -> Void, cancelFucnt: @escaping () -> Void) {

        showAlertApi("Uwaga", text: "Wystąpił błąd w komunikacji z serwerem.", succes: repeatFunction, cancel: cancelFucnt)
    }


    func showAlertApi(_ title: String, text: String, succes: @escaping () -> Void, cancel: @escaping () -> Void, show: Bool = true) {
        let text2 = show ? text + " Czy chcesz spróbować ponownie ?" : text;
        let alertController = UIAlertController(title: title, message: text2, preferredStyle: .alert)
        if (show) {
            alertController.addAction(UIAlertAction(title: "Tak", style: .default, handler: {
                (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
                succes()

            }))
            alertController.addAction(UIAlertAction(title: "Nie", style: .cancel, handler: {
                (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
                cancel()
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
                cancel()
            }))
        }

        present(alertController, animated: true, completion: nil)
    }

    func openUrlString(_ text: String) {
        if let url = URL(string: text) {
            UIApplication.shared.openURL(url)
        }
    }
}

extension UITableViewController {

    func createLabelForSectionTitle(_ text: String, middle: Bool = false, height: CGFloat = 48) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: height))
        view.backgroundColor = UIColor.greyBackgroundColor()
        let label = UILabel(frame: CGRect(x: 11, y: 0, width: self.tableView.frame.size.width - 11, height: height))
        let font = UIFont.kjnTextStyle2Font()
        label.font = font
        label.text = text
        if (middle) {
            label.textAlignment = .center
        }
        label.textColor = UIColor.blackWithAlpha()
        view.addSubview(label)
        view.layer.addBorder(UIRectEdge.top, color: UIColor.lightGray(), thickness: 1)
        return view
    }


    func createTopBorder(_ tableViewCell: UITableViewCell) {
        tableViewCell.layer.addBorder(UIRectEdge.bottom, color: UIColor.lightGray(), thickness: 1)
    }


}

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height * 1.2), animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: { [unowned self] in
                self.sendActions(for: .valueChanged)
                self.beginRefreshing()
            })
        }

    }
}

extension UIViewController: Unauthorized,LogoutSucces {

    func unauthorized(_ text: String) {
        let alertController = UIAlertController(title: StringHolder.autorizationError, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)

            let loginMenager = UserLoginEnum.getUserLogin()
            if(loginMenager.getLoginType() != UserLoginEnum.email){
                loginMenager.logout(self)
            }else{
                let controller = EntryViewController(nibName: "EntryViewController", bundle: nil)
                UserDataHolder.sharedInstance.userEmail = nil
                UserDataHolder.sharedInstance.userToken = nil
                UserDataHolder.sharedInstance.userImage = nil
                UserDataHolder.sharedInstance.userName = nil
                self.present(controller, animated: true, completion: nil)
            }
        }))
        present(alertController, animated: true, completion: nil)

    }

    func succes() {
        let controller = EntryViewController(nibName: "EntryViewController", bundle: nil)
        self.present(controller, animated: true, completion: nil)
    }

    func failed(_ text: String) {
        let controller = EntryViewController(nibName: "EntryViewController", bundle: nil)
        UserDataHolder.sharedInstance.userEmail = nil
        UserDataHolder.sharedInstance.userToken = nil
        UserDataHolder.sharedInstance.userImage = nil
        UserDataHolder.sharedInstance.userName = nil
        self.present(controller, animated: true, completion: nil)
    }


}
