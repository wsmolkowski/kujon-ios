//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LectureProviderProtocol: JsonProviderProtocol {
    associatedtype T = LectureResponse

    func loadLectures(_ date: String)
    func loadLectures(_ date: Date)

}

protocol LectureProviderDelegate: ErrorResponseProtocol {
    func onLectureLoaded(_ lectures: Array<Lecture>,date:Date)

}

class LectureProvider: RestApiManager, LectureProviderProtocol {

weak var delegate: LectureProviderDelegate!
    var endpoint: String! = nil
    var endpointParameter: String = "?lecturers_info=False"
    private var firstPart = "/ttusers/"

    func loadLectures(_ date: String) {
        endpoint = firstPart + date
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in
                if  let strongSelf = self,
                    let lectureResponse = try! strongSelf.changeJsonToResposne(json,errorR: strongSelf.delegate){
                    strongSelf.delegate?.onLectureLoaded(lectureResponse.data,date: Date())
                }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })
    }

    func loadLectures(_ date: Date) {
        endpoint = firstPart + date.dateToString()
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in
            if  let strongSelf = self,
                let lectureResponse = try! strongSelf.changeJsonToResposne(json,errorR: strongSelf.delegate){
                strongSelf.delegate?.onLectureLoaded(lectureResponse.data, date: date)
            }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })
    }


    func setLecturer(lecturerId:String! = nil){
       if(lecturerId == nil){
           self.firstPart =  "/ttusers/"
       }else {
           self.firstPart =  "/ttlecturers/" + lecturerId + "/"
       }
    }
    override func getMyUrl() -> String {
        return baseURL + endpoint + endpointParameter
    }

}