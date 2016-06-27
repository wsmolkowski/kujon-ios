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
    func onLecturersLoaded(lecturers: Array<SimpleUser>)
}

class LecturerProvider: RestApiManager, LecturerProviderProtocol {

    var delegate: LecturerProviderDelegate!


    func loadLecturers() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                let lecturerResponse = try! self.changeJsonToResposne(json)
                self.delegate?.onLecturersLoaded(lecturerResponse.data)
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate.onErrorOccurs()
            }
        }, onError: { self.delegate?.onErrorOccurs() })

    }

    override func getMyUrl() -> String {
        return baseURL + "/lecturers"
    }

}