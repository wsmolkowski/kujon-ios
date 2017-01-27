//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class CoordinatorsSection: LecturersSection {


    override func fillUpWithData(_ courseDetails: CourseDetails) {
        if(courseDetails.coordinators != nil){

            super.list = courseDetails.coordinators
        }
    }


    override func getSectionTitle() -> String {
        return StringHolder.coordinators
    }

    override func getMyCellId()->String {
        return "coordinatorsId"
    }

    


}
