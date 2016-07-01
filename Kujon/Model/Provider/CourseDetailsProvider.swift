//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol CourseDetailsProviderProtocol: JsonProviderProtocol {
    associatedtype T = CourseDetailsResponse

    func loadCourseDetails(course: Course)
}

protocol CourseDetailsProviderDelegate: ErrorResponseProtocol {
    func onCourseDetailsLoaded(courseDetails: CourseDetails)
}

class CourseDetailsProvider:RestApiManager , CourseDetailsProviderProtocol {
    var endpoint:String! = nil
    var delegate: CourseDetailsProviderDelegate! = nil
    func loadCourseDetails(course: Course) {
        endpoint = course.courseId + "/" + course.termId

        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                let courseResponse = try! self.changeJsonToResposne(json)
                self.delegate?.onCourseDetailsLoaded(courseResponse.details)
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate?.onErrorOccurs()
            }
        }, onError: { self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return baseURL + "/courseseditions/" + endpoint
    }

    override func getMyFakeJsonName() -> String! {
        return "CourseEditions"
    }


}