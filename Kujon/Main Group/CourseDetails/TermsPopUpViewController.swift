//
//  TermsPopUpViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 14/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TermsPopUpViewController: PopUpViewController {

    @IBOutlet weak var popUpView: UILabel!
    @IBOutlet weak var endindTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var termActiveLabel: UILabel!
    @IBOutlet weak var termNumberLabel: UILabel!
    @IBOutlet weak var termNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showInView(term:Term){
        endDateLabel.text = term.endDate
        endindTimeLabel.text = term.finishDate
        startDateLabel.text = term.startDate
        termActiveLabel.text = term.active ? StringHolder.yes:StringHolder.no
        termNameLabel.text = term.name
        termNumberLabel.text = term.termId
    }

    override func setMyPopUpView() -> UIView! {
        return popUpView
    }
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
