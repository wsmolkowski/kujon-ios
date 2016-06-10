//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
protocol LectureProviderDelegate: ErrorResponseProtocol {
    func onLectureLoaded(lectures: Array<Lecture>)

}
class LectureProvider {
    var delegate: LectureProviderDelegate!

    func loadLectures(date:String) {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("Schedule", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            let schedule = try! LectureResponse.decode(json)
            delegate?.onLectureLoaded(schedule.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }
}
