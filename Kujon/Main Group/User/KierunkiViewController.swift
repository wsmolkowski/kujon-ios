//
//  KierunkiViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 24/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class KierunkiViewController: PopUpViewController {


    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var kierunekLabel: UILabel!

    @IBOutlet weak var levelLabel: UILabel!

    @IBOutlet weak var trybeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timeOfStudyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var ectsLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    var myProgramme: Programme! = nil;
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func setMyPopUpView() -> UIView! {
        return popUpView
    }


    func close() {
        self.removeAnimate()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showInView(withProgramme programme: Programme!) {

        if (programme != nil) {
            self.myProgramme = programme
            levelLabel.text = StringHolder.level + ": " + myProgramme.levelOfStudies!
            descriptionLabel.text = StringHolder.description + ": " + myProgramme.description
            timeOfStudyLabel.text = StringHolder.time_length + ": " + myProgramme.duration!
            idLabel.text = StringHolder.identificator + ": " + myProgramme.id
            trybeLabel.text = StringHolder.tryb + ": " + myProgramme.modeOfStudies!
            if (myProgramme.ectsUsedSum != nil) {
                ectsLabel.text = StringHolder.ectsPoints + ": " + String(myProgramme.ectsUsedSum!)
            }

            kierunekLabel.text = myProgramme.name!.characters.split {
                $0 == ","
            }.map(String.init)[0]
            self.view.userInteractionEnabled = true
            okButton.addTopBorder(UIColor.lightGray(), width: 1)
        }


    }


    @IBAction func dismissClick(sender: AnyObject) {
        removeAnimate()
    }


}
