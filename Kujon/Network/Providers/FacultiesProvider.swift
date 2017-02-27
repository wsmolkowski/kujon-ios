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
    func onFacultiesLoaded(_ list: Array<Facultie>)
}

class FacultiesProvider: RestApiManager, FacultiesProviderProtocol {

weak var delegate: FacultiesProviderDelegate! = nil


    override func getMyUrl() -> String {
        return baseURL+"/faculties"
    }

    func loadFaculties() {
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let faculties = try! strongSelf.changeJsonToResposne(json,errorR: strongSelf.delegate){
                strongSelf.delegate?.onFacultiesLoaded(faculties.list)
            }

        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })


    }

}
