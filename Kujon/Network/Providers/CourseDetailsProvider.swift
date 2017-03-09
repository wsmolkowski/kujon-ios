//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol CourseDetailsProviderProtocol: JsonParsing {
    associatedtype T = CourseDetailsResponse

    func loadCourseDetails(_ course: Course)
    func loadCourseDetails(_ courseId : String, andTermId termId: String)
    func loadCourseDetails(_ courseId : String)
}

protocol CourseDetailsProviderDelegate: ErrorHandlingDelegate {
    func onCourseDetailsLoaded(_ courseDetails: CourseDetails)
}

class CourseDetailsProvider:RestApiManager , CourseDetailsProviderProtocol {
    var endpoint:String! = nil
    weak var delegate: CourseDetailsProviderDelegate! = nil
    internal var isFetching: Bool = false

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
        isFetching = true
    }

    func loadCourseDetails(_ courseId: String) {
        let courseString = courseId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        endpoint = "/courses/" + courseString!
        makeApiShot()
        isFetching = true
    }


    private func makeApiShot(){
        self.makeHTTPAuthenticatedGetRequest({ [weak self] json in
            self?.isFetching = false

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            do {
                if let courseResponse = try strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                    strongSelf.delegate?.onCourseDetailsLoaded(courseResponse.details)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                strongSelf.delegate?.onErrorOccurs()
            }
        }, onError: {[weak self] text in
            self?.isFetching = false
            self?.delegate?.onErrorOccurs() })
    }


    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    override func getMyFakeJsonName() -> String! {
        return "CourseEditions"
    }


}
