//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol CourseProviderDelegate: ErrorResponseProtocol {

    func coursesProvided(_ courses: Array<CoursesWrapper>)

}

class CourseProvider: RestApiManager {
    var delegate: CourseProviderDelegate! = nil

    func provideCourses() {
        self.makeHTTPAuthenticatedGetRequest({
            data in
            
            if (data != nil) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    var arrayOfCourses = Array<CoursesWrapper>()
                    if  let json = json as? NSDictionary,
                        let array = json["data"] as? NSArray {
                        for courseDic in array  {
                            let courseDic = courseDic as! NSDictionary
                            let key = courseDic.allKeys[0] as! String
                            if let dictionaryForGivenKey = courseDic[key] as? NSArray {
                                let courseWrapper = CoursesWrapper()
                                courseWrapper.title = key
                                for index in 0...dictionaryForGivenKey.count-1{
                                    let course = try Course.decode(dictionaryForGivenKey[index])
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
