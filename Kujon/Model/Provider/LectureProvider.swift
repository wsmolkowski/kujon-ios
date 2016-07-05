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
    func loadLectures(date: String) {
        endpoint = "/tt/" + date
        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                if let lectureResponse = try! self.changeJsonToResposne(json,onError: {
                    self.delegate?.onErrorOccurs()
                }){
                    self.delegate?.onLectureLoaded(lectureResponse.data)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate.onErrorOccurs()
            }
        }, onError: {
            self.delegate?.onErrorOccurs()
        })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

}
