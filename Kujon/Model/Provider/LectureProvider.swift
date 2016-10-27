//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LectureProviderProtocol: JsonProviderProtocol {
    associatedtype T = LectureResponse

    func loadLectures(_ date: String)

}

protocol LectureProviderDelegate: ErrorResponseProtocol {
    func onLectureLoaded(_ lectures: Array<Lecture>)

}

class LectureProvider: RestApiManager, LectureProviderProtocol {

weak var delegate: LectureProviderDelegate!
    var endpoint: String! = nil
    var endpointParameter: String = "?lecturers_info=False"

    func loadLectures(_ date: String) {
        endpoint = "/tt/" + date
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in
                if let lectureResponse = try! self.changeJsonToResposne(json,errorR: self.delegate){
                    self.delegate?.onLectureLoaded(lectureResponse.data)
                }
        }, onError: {[unowned self] text in
            self.delegate?.onErrorOccurs()
        })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint + endpointParameter
    }

}
