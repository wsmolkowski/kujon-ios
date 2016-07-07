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

    func showInView( withProgramme programme: Programme) {


        self.myProgramme = programme
        levelLabel.text = myProgramme.levelOfStudies
        descriptionLabel.text = StringHolder.description + ": " + myProgramme.description
        timeOfStudyLabel.text = myProgramme.duration
        idLabel.text = myProgramme.id
        trybeLabel.text = myProgramme.modeOfStudies
        kierunekLabel.text = myProgramme.name
        self.view.userInteractionEnabled = true

    }




    @IBAction func dismissClick(sender: AnyObject) {
        removeAnimate()
    }



}
