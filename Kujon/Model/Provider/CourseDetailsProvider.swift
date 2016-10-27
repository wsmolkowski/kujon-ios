//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol CourseDetailsProviderProtocol: JsonProviderProtocol {
    associatedtype T = CourseDetailsResponse

    func loadCourseDetails(_ course: Course)
    func loadCourseDetails(_ courseId : String, andTermId termId: String)
    func loadCourseDetails(_ courseId : String)
}

protocol CourseDetailsProviderDelegate: ErrorResponseProtocol {
    func onCourseDetailsLoaded(_ courseDetails: CourseDetails)
}

class CourseDetailsProvider:RestApiManager , CourseDetailsProviderProtocol {
    var endpoint:String! = nil
   weak var delegate: CourseDetailsProviderDelegate! = nil
    func loadCourseDetails(_ course: Course) {
        let courseString = course.courseId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let termsString = course.termId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        endpoint = "/courseseditions/" + courseString! + "/" + termsString!
        makeApiShot()

    }

    func loadCourseDetails(_ courseId: String, andTermId termId: String) {
        let courseString = courseId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let termsString = termId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        endpoint = "/courseseditions/" + courseString! + "/" + termsString!
        makeApiShot()
    }

    func loadCourseDetails(_ courseId: String) {
        let courseString = courseId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        endpoint = "/courses/" + courseString!
        makeApiShot()
    }


    private func makeApiShot(){
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in
            do {
                if let courseResponse = try self.changeJsonToResposne(json,errorR: self.delegate){

                    self.delegate?.onCourseDetailsLoaded(courseResponse.details)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate?.onErrorOccurs()
            }
        }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
    }


    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    override func getMyFakeJsonName() -> String! {
        return "CourseEditions"
    }


}
