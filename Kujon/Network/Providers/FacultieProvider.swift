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
            [weak self] json in
            guard let strongSelf = self else {
                return
            }
                if let facult = try? strongSelf.changeJsonToResposne(json,errorR: strongSelf.delegate){
                    strongSelf.delegate?.onFacultieLoaded(facult.list)
                }
        }, onError: {[weak self] text in self?.delegate?.onErrorOccurs() })
    }

}
