//
//  CoursePopUpViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CoursePopUpViewController: PopUpViewController {

    @IBOutlet weak var lectureTypeLabel: UILabel!
    @IBOutlet weak var lectureGroupLabel: UILabel!
    @IBOutlet weak var lectureBuldingNameLabel: UILabel!
    @IBOutlet weak var lectureRoomNumberLabel: UILabel!
    @IBOutlet weak var lectureTimeLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setMyPopUpView() -> UIView! {
        return popUpView
    }



    func showInView(parentView: UIView! ,withLecture lectureWrap : LectureWrapper, animated: Bool){
        parentView.addSubview(self.view)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.topAnchor.constraintEqualToAnchor(parentView.topAnchor, constant: 0).active = true
        self.view.bottomAnchor.constraintEqualToAnchor(parentView.bottomAnchor, constant: 0).active = true
        self.view.leadingAnchor.constraintEqualToAnchor(parentView.leadingAnchor, constant: 0).active = true
        self.view.trailingAnchor.constraintEqualToAnchor(parentView.trailingAnchor, constant: 0).active = true
        
        let lecture = lectureWrap.lecture
        lectureTypeLabel.text  = "Typ: " + lecture.type
        lectureGroupLabel.text  = "Grupa: " + String(lecture.groupNumber)
        lectureBuldingNameLabel.text  = "Budynek: " + lecture.buldingName
        lectureRoomNumberLabel.text  = "Sala: " + lecture.roomNumber
        lectureTimeLabel.text  = lectureWrap.startTime + ":" + lecture.endTime

        if animated
        {
            self.showAnimate()
        }
    }

    
    @IBAction func seeLectureButtonAction(sender: AnyObject) {
    }

    @IBAction func okButtonAction(sender: AnyObject) {
        removeAnimate()
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
