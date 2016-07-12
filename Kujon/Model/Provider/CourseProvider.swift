//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol CourseProviderDelegate: ErrorResponseProtocol {

    func coursesProvided(courses: Array<CoursesWrapper>)

}

class CourseProvider: RestApiManager {
    var delegate: CourseProviderDelegate! = nil

    func provideCourses() {
        self.makeHTTPAuthenticatedGetRequest({
            data in
            if (data != nil) {
                do {

                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    _ = json["status"]!
                    var arrayOfCourses = Array<CoursesWrapper>()
                    if let dictData = json["data"]! {
                        let array = try dictData as! NSArray
                        try array.forEach {
                            courseDic in
                            let insideDic = courseDic as! NSDictionary
                            let key = insideDic.allKeys[0]
                            if let dictionaryForGivenKey = courseDic[key as! String]! {
                                var courseWrapper = CoursesWrapper()
                                courseWrapper.title = key as! String
                                for index in 0...dictionaryForGivenKey.count-1{
                                    var course = try Course.decode(dictionaryForGivenKey[index])
                                    courseWrapper.courses.append(course)
                                }
                                arrayOfCourses.append(courseWrapper)
                            }

                        }
                    }
                    self.delegate?.coursesProvided(arrayOfCourses)

                } catch {
                    NSlogManager.showLog("JSON serialization failed:  \(error)")
                    self.delegate.onErrorOccurs()
                }

            }

        }, onError: { text in self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return super.getMyUrl() + "/courseseditionsbyterm"
    }

}
