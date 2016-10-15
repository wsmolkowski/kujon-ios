//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultieProviderProtocol: JsonProviderProtocol {
    associatedtype T = FacultieResponse

    func loadFacultie(_ id: String)
}
 protocol FacultieProviderDelegate: ErrorResponseProtocol {
    func onFacultieLoaded(_ fac: Facultie)
}

class FacultieProvider: RestApiManager, FacultieProviderProtocol {

weak var delegate: FacultieProviderDelegate! = nil

    var endpoint: String! = nil
    override func getMyUrl() -> String {
        return baseURL + "/faculties/" + endpoint
    }

    func loadFacultie(_ id: String) {
        self.endpoint = id
        self.makeHTTPAuthenticatedGetRequest({
            json in
                if let facult = try! self.changeJsonToResposne(json,errorR: self.delegate){
                    self.delegate?.onFacultieLoaded(facult.list)
                }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }

}
