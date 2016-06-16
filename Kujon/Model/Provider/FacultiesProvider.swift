//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultiesProviderProtocol: JsonProviderProtocol {
    associatedtype T = FacultieResposne

    func loadFaculties()
}

protocol FacultiesProviderDelegate: ErrorResponseProtocol {
    func onFacultiesLoaded(list: Array<Facultie>)
}

class FacultiesProvider: RestApiManager, FacultiesProviderProtocol {
    static let sharedInstance = FacultiesProvider()
    var delegate: FacultiesProviderDelegate! = nil


    override func getMyUrl() -> String {
        return baseURL+"/faculties"
    }

    func loadFaculties() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
            let faculties = try! self.changeJsonToResposne(json)
            self.delegate?.onFacultiesLoaded(faculties.list)
        }, onError: { self.delegate?.onErrorOccurs() })


    }

}
