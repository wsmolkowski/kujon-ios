//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ParticipantsSection:LecturersSection {



    override func getMyCellId() -> String {
        return "participantsId"
    }

    override func fillUpWithData(courseDetails: CourseDetails) {
        if(courseDetails.participants != nil){
            self.list = courseDetails.participants
        }
    }

    override func getSectionTitle() -> String {
        return StringHolder.students
    }

    override func reactOnSectionClick(position: Int, withController controller: UINavigationController?) {
        if let myUser: SimpleUser = self.list[position] {


            let teachController = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: NSBundle.mainBundle())
            teachController.userId = myUser.id
            controller?.pushViewController(teachController, animated: true)


        }
    }


}
