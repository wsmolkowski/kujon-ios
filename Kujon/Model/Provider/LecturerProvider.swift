//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LecturerProviderProtocol: JsonProviderProtocol {
    associatedtype T = LecturersResponse

    func loadLecturers()
}


protocol LecturerProviderDelegate: ErrorResponseProtocol {
    func onLecturersLoaded(_ lecturers: Array<SimpleUser>)
}

class LecturerProvider: RestApiManager, LecturerProviderProtocol {

    weak  var delegate: LecturerProviderDelegate!


    func loadLecturers() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
               if let lecturerResponse = try! self.changeJsonToResposne(json,errorR: self.delegate){

                   self.delegate?.onLecturersLoaded(lecturerResponse.data)
               }
        }, onError: {text in self.delegate?.onErrorOccurs() })

    }

    override func getMyUrl() -> String {
        return baseURL + "/lecturers"
    }

}
