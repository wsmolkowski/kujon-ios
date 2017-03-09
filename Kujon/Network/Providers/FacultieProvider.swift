//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultieProviderProtocol: JsonParsing {
    associatedtype T = FacultieResponse

    func loadFacultie(_ id: String)
}
 protocol FacultieProviderDelegate: ResponseHandlingDelegate {
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

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let facult = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate){
                strongSelf.delegate?.onFacultieLoaded(facult.list)
            }

            }, onError: {[weak self] text in
                self?.delegate?.onErrorOccurs()
        })
    }
    
}
