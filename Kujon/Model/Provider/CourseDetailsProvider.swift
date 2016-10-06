//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol CourseDetailsProviderProtocol: JsonProviderProtocol {
    associatedtype T = CourseDetailsResponse

    func loadCourseDetails(course: Course)
    func loadCourseDetails(courseId : String, andTermId termId: String)
    func loadCourseDetails(courseId : String)
}

protocol CourseDetailsProviderDelegate: ErrorResponseProtocol {
    func onCourseDetailsLoaded(courseDetails: CourseDetails)
}

class CourseDetailsProvider:RestApiManager , CourseDetailsProviderProtocol {
    var endpoint:String! = nil
   weak var delegate: CourseDetailsProviderDelegate! = nil
    func loadCourseDetails(course: Course) {
        let courseString = course.courseId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let termsString = course.termId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        endpoint = "/courseseditions/" + courseString! + "/" + termsString!
        makeApiShot()

    }

    func loadCourseDetails(courseId: String, andTermId termId: String) {
        let courseString = courseId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let termsString = termId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        endpoint = "/courseseditions/" + courseString! + "/" + termsString!
        makeApiShot()
    }

    func loadCourseDetails(courseId: String) {
        let courseString = courseId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        endpoint = "/courses/" + courseString!
        makeApiShot()
    }


    private func makeApiShot(){
        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                if let courseResponse = try! self.changeJsonToResposne(json,errorR: self.delegate){

                    self.delegate?.onCourseDetailsLoaded(courseResponse.details)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate?.onErrorOccurs()
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }


    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    override func getMyFakeJsonName() -> String! {
        return "CourseEditions"
    }


}
