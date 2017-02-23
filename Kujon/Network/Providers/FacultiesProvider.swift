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
            [unowned self] json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let faculties = try? self.changeJsonToResposne(json,errorR: self.delegate){

                self.delegate?.onFacultiesLoaded(faculties.list)
            }

        }, onError: {[unowned self] text in
            self.delegate?.onErrorOccurs()
        })


    }

}
