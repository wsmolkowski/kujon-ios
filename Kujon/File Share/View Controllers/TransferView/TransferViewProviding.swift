//
//  TransferViewProviding.swift
//  Kujon
//
//  Created by Adam on 17.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

protocol TransferViewProviding: class  {

    var transferView: TransferView? { get set }

    func addTransferView(toParent tableView: UITableView, trackTransfer transfer: Transferable?)

    func adjustFloatingTransferView(_ scrollView: UIScrollView)

    func closeTransferView()

}

extension TransferViewProviding {

    private var fadeDuration: TimeInterval {
        return 0.2
    }

    func addTransferView(toParent tableView: UITableView, trackTransfer transfer: Transferable?) {
        guard let transfer = transfer else {
            return
        }

        guard let transferView = Bundle.main.loadNibNamed("TransferView", owner: self, options: nil)?.first as? TransferView
            else { return }

        transferView.transfer = transfer
        transferView.frame.size.width = tableView.bounds.size.width
        transferView.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        transferView.alpha = 0.0
        tableView.addSubview(transferView)
        tableView.bringSubview(toFront: transferView)
        self.transferView = transferView

        UIView.animate(withDuration: fadeDuration, delay: 0.0, options: .curveEaseOut, animations: {
            transferView.alpha = 1.0
        }, completion: nil)
    }

    func adjustFloatingTransferView(_ scrollView: UIScrollView) {
        guard let transferView = transferView else {
            return
        }
        var newFrame = transferView.frame
        newFrame.origin.x = 0
        if scrollView.contentOffset.y > 0.0 {
            newFrame.origin.y = scrollView.contentOffset.y
            print("correcting")
        }
        transferView.frame = newFrame
        print("view frame: ", newFrame)
        scrollView.bringSubview(toFront:transferView)
    }

    func closeTransferView() {
        UIView.animate(withDuration: fadeDuration, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.transferView?.alpha = 0.0
        }) { [weak self] _ in
            self?.transferView?.removeFromSuperview()
            self?.transferView = nil
        }
    }
    
}

