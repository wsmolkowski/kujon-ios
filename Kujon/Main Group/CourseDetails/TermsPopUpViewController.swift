//
//  TermsPopUpViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 14/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TermsPopUpViewController: PopUpViewController {

    @IBOutlet weak var hahaView: TermView!
    @IBOutlet weak var endindTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var termActiveLabel: UILabel!
    @IBOutlet weak var termNumberLabel: UILabel!
    @IBOutlet weak var termNameLabel: UILabel!

    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

    func showInView(_ term:Term){
        endDateLabel.text = term.endDate
        endindTimeLabel.text = term.finishDate
        startDateLabel.text = term.startDate
        termActiveLabel.text = term.active ? StringHolder.yes:StringHolder.no
        termNameLabel.text = term.name
        termNumberLabel.text = term.termId
    }

    override func setMyPopUpView() -> UIView! {
        return hahaView
    }

}
