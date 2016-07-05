//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultieProviderProtocol: JsonProviderProtocol {
    associatedtype T = FacultieResponse

    func loadFacultie(id: String)
}

protocol FacultieProviderDelegate: ErrorResponseProtocol {
    func onFacultieLoaded(fac: Facultie)
}

class FacultieProvider: RestApiManager, FacultieProviderProtocol {

    var delegate: FacultieProviderDelegate! = nil

    var endpoint: String! = nil
    override func getMyUrl() -> String {
        return baseURL + "/faculties/" + endpoint
    }

    func loadFacultie(id: String) {
        self.endpoint = id
        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {

                if let facult = try! self.changeJsonToResposne(json,onError: {
                    self.delegate?.onErrorOccurs()
                }){
                    self.delegate?.onFacultieLoaded(facult.list)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate.onErrorOccurs()
            }
        }, onError: { self.delegate?.onErrorOccurs() })


    }

}
