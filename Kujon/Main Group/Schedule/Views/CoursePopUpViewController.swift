//
//  CoursePopUpViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

 protocol ShowCourseDetailsDelegate: class {
    func showCourseDetails()
}

class CoursePopUpViewController: PopUpViewController {

    @IBOutlet weak var tekstLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var popUpView: UIView!

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var showCourseButton: UIButton!
    weak var delegate:ShowCourseDetailsDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setMyPopUpView() -> UIView! {
        return popUpView
    }



    func showInView(withLecture lectureWrap : LectureWrapper){
        okButton.addTopBorder( UIColor.lightGray(), width: 1)
        showCourseButton.addTopBorder( UIColor.lightGray(), width: 1)
        let lecture = lectureWrap.lecture
        let string = lectureWrap.startTime + " - " + lectureWrap.endTime + "\n " + createNiceString(StringHolder.classRoom,two: lecture.roomNumber) +
                 " \n " + createNiceString(StringHolder.bulding,two: lecture.buldingName) + " \n " +
                createNiceString(StringHolder.group,two: String(lecture.groupNumber)) + " \n " +
                createNiceString(StringHolder.type,two: lecture.type)
            tekstLabel.text = string
        
        courseTitle.text = lecture.courseName

    }

    private func createNiceString(_ one:String, two:String)->String{
        return String(format: "%@: %@",one,two)
    }

    
    @IBAction func seeLectureButtonAction(_ sender: AnyObject) {
        self.removeAnimate({self.delegate?.showCourseDetails()})
    }

    @IBAction func okButtonAction(_ sender: AnyObject) {
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
