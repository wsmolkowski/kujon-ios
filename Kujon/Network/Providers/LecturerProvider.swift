//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LecturerProviderProtocol: JsonParsing {
    associatedtype T = LecturersResponse

    func loadLecturers()
}


protocol LecturerProviderDelegate: ResponseHandlingDelegate {
    func onLecturersLoaded(_ lecturers: Array<SimpleUser>)
}

class LecturerProvider: RestApiManager, LecturerProviderProtocol {

    weak  var delegate: LecturerProviderDelegate!


    func loadLecturers() {
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let lecturerResponse = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                strongSelf.delegate?.onLecturersLoaded(lecturerResponse.data)
            }

        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })

    }

    override func getMyUrl() -> String {
        return baseURL + "/lecturers"
    }

}
