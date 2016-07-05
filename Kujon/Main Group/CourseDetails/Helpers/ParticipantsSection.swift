//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ParticipantsSection:LecturersSection {

    override func reactOnSectionClick(position: Int, withController controller: UINavigationController?) {

    }

    override func getMyCellId() -> String {
        return "participantsId"
    }

    override func fillUpWithData(courseDetails: CourseDetails) {
        if(courseDetails.participants != nil){
            self.list = courseDetails.participants
        }
    }

    override func getSectionTitle() -> String {
        return "Studenci"
    }


}
