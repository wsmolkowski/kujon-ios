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
            [unowned self] data in
            
            if (data != nil) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])

                    let error = try? ErrorClass.decode(json)
                    if let error = error, let code = error.code {
                        switch code {
                        case 504:
                            self.delegate.onUsosDown()
                        default:
                            self.delegate.onErrorOccurs(error.message)
                        }
                        return
                    }
                    let arrayOfCourses: NSMutableArray = NSMutableArray()
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
                                arrayOfCourses.add(courseWrapper)
                            }
                        }
                    }

                    self.delegate?.coursesProvided(arrayOfCourses.copy() as! Array<CoursesWrapper>)

                } catch {
                    NSlogManager.showLog("JSON serialization failed:  \(error)")
                    self.delegate.onErrorOccurs()
                }

            }

        }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return super.getMyUrl() + "/courseseditionsbyterm"
    }

}
