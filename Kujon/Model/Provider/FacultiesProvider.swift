//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultiesProviderProtocol: JsonProviderProtocol {
    associatedtype T = FacultiesResposne

    func loadFaculties()
}

protocol FacultiesProviderDelegate: ErrorResponseProtocol {
    func onFacultiesLoaded(list: Array<Facultie>)
}

class FacultiesProvider: RestApiManager, FacultiesProviderProtocol {

weak var delegate: FacultiesProviderDelegate! = nil


    override func getMyUrl() -> String {
        return baseURL+"/faculties"
    }

    func loadFaculties() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
                if let faculties = try! self.changeJsonToResposne(json,errorR: self.delegate){

                    self.delegate?.onFacultiesLoaded(faculties.list)
                }
        }, onError: {text in self.delegate?.onErrorOccurs() })


    }

}
