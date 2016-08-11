//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

import UIKit

class LectureCellHandler: CellHandlerProtocol {

    let wrapper: LectureWrapper

    init(lectureWrapper: LectureWrapper) {
        self.wrapper = lectureWrapper
    }

    func handleCell(inout cell: UITableViewCell) {


        (cell as! LectureTableViewCell).timeLabel.attributedText = setTime()
        let lecturer = wrapper.lecture.lecturers[0] as SimpleUser!
        cell.selectionStyle = UITableViewCellSelectionStyle.None
//        (cell as! LectureTableViewCell).topic.backgroundColor  =  UIColor.kujonDarkerBlueColor()
        if (lecturer == nil) {
            let text  = wrapper.lecture.name
            let atrText = NSMutableAttributedString(string: text)
            atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyle5Font()!, range: NSMakeRange(0, count(wrapper.lecture.courseName)))
            (cell as! LectureTableViewCell).topic.attributedText = atrText
        } else {
            let text  = wrapper.lecture.courseName + " \n" + wrapper.lecture.type + " \n" + lecturer.getNameWithTitles()
            let atrText = NSMutableAttributedString(string: text)
            var lenght = 0
            atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyle5Font()!, range: NSMakeRange(0, count(wrapper.lecture.courseName)))
            lenght = count(wrapper.lecture.courseName)+2
            atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyle2Font()!, range: NSMakeRange(lenght, count(wrapper.lecture.type)))
            lenght += count(wrapper.lecture.type)+2
            atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyle5Font()!, range: NSMakeRange(lenght, count(lecturer.getNameWithTitles())))

            (cell as! LectureTableViewCell).topic.attributedText = atrText;
            (cell as! LectureTableViewCell).vieww.layer.cornerRadius = 3
            (cell as! LectureTableViewCell).vieww.backgroundColor  =  UIColor.kujonDarkerBlueColor()

        }
    }

    private func count(text:String)->Int{
        return text.characters.count
    }
    private func setTime()->NSAttributedString{
        let text  = wrapper.startTime + " \n" + wrapper.endTime + " \n" + "s. " + wrapper.lecture.roomNumber
        let atrText = NSMutableAttributedString(string: text)
        var lenght = 0
        atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyleFont()!, range: NSMakeRange(0, count(wrapper.startTime)))
        atrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, count(wrapper.startTime)))
        lenght = count(wrapper.startTime)+2
        atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyleFont()!, range: NSMakeRange(lenght, count(wrapper.endTime)))
        atrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(lenght, count(wrapper.endTime)))
        lenght += count(wrapper.endTime)+2
        atrText.addAttribute(NSFontAttributeName, value: UIFont.kjnTextStyleFont()!, range: NSMakeRange(lenght, count("s. " + wrapper.lecture.roomNumber)))
        atrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackWithAlpha(), range:NSMakeRange(lenght, count("s. " + wrapper.lecture.roomNumber)))
        return atrText
    }


}
