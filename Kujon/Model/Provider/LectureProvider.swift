//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LectureProviderProtocol: JsonProviderProtocol {
    associatedtype T = LectureResponse

    func loadLectures(date: String)

}

protocol LectureProviderDelegate: ErrorResponseProtocol {
    func onLectureLoaded(lectures: Array<Lecture>)

}

class LectureProvider: RestApiManager, LectureProviderProtocol {

    var delegate: LectureProviderDelegate!
    var endpoint: String! = nil
    var endpointParameter: String = "?lecturers_info=False"

    func loadLectures(date: String) {
        endpoint = "/tt/" + date
        self.makeHTTPAuthenticatedGetRequest({
            json in
                if let lectureResponse = try! self.changeJsonToResposne(json,errorR: self.delegate){
                    self.delegate?.onLectureLoaded(lectureResponse.data)
                }
        }, onError: {text in
            self.delegate?.onErrorOccurs()
        })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint + endpointParameter
    }

}
