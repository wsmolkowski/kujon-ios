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



    func showInView(withLecture lectureWrap : LectureWrapper){

        
        let lecture = lectureWrap.lecture
        lectureTypeLabel.text  = createNiceString(StringHolder.type,two: lecture.type)
        lectureGroupLabel.text  = createNiceString(StringHolder.group,two: String(lecture.groupNumber))
        lectureBuldingNameLabel.text  = createNiceString(StringHolder.bulding,two: lecture.buldingName)
        lectureRoomNumberLabel.text  = createNiceString(StringHolder.classRoom,two: lecture.roomNumber)
        lectureTimeLabel.text  = lectureWrap.startTime + ":" + lecture.endTime
        courseTitle.text = lecture.courseName

    }

    private func createNiceString(one:String, two:String)->String{
        return String(format: "%@: %@",one,two)
    }

    
    @IBAction func seeLectureButtonAction(sender: AnyObject) {
    }

    @IBAction func okButtonAction(sender: AnyObject) {
        self.removeAnimate()
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
