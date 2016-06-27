//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol CourseProviderDelegate: ErrorResponseProtocol {

    func coursesProvided(courses: Array<Course>)

}

class CourseProvider: RestApiManager {
    var delegate: CourseProviderDelegate! = nil

    func provideProgrammes() {
        self.makeHTTPAuthenticatedGetRequest({
            data in
            if (data != nil) {
                do {

                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    _ = json["status"]!
                    var arrayOfCourses = Array<Course>()
                    if let dictData = json["data"]! {
                        let array = try dictData as! NSArray
                        try array.forEach {
                            courseDic in
                            let insideDic = courseDic as! NSDictionary
                            let key = insideDic.allKeys[0]
                            if let secDic = courseDic[key as! String]! {
                                var course = try Course.decode(secDic[0])
                                arrayOfCourses.append(course)
                            }

                        }


                    }
                    self.delegate?.coursesProvided(arrayOfCourses)

                } catch {
                    print("JSON serialization failed:  \(error)")
                    self.delegate?.onErrorOccurs()
                }

            }

        }, onError: { self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return super.getMyUrl() + "/programmes"
    }

}
