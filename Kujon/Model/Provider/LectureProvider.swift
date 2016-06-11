//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LectureProviderProtocol: JsonProviderProtocol {

    typealias T = LectureResponse

    func loadLectures(date: String)

}

protocol LectureProviderDelegate: ErrorResponseProtocol {
    func onLectureLoaded(lectures: Array<Lecture>)

}

class LectureProvider: LectureProviderProtocol {
    var delegate: LectureProviderDelegate!

    func loadLectures(date: String) {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("Schedule", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let lectureResponse = try! self.changeJsonToResposne(jsonData)
            delegate?.onLectureLoaded(lectureResponse.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }
}
