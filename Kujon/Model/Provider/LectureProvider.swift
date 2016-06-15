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

class LectureProvider: LectureProviderProtocol {
    var delegate: LectureProviderDelegate!

    func loadLectures(date: String) {
        do {
            let jsonData = try JsonDataLoader.loadJson("Schedule")
            let lectureResponse = try! self.changeJsonToResposne(jsonData)
            delegate?.onLectureLoaded(lectureResponse.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }
}
