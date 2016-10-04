//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultySearchProviderProtocol: JsonProviderProtocol {
    associatedtype T = FacultySearchResponse


}

class FacultySearchProvider: RestApiManager, FacultySearchProviderProtocol, SearchProviderProtocol {

    var delegate: SearchProviderDelegate!
    func setDelegate(delegate: SearchProviderDelegate) {
        self.delegate = delegate
    }

    override func getMyUrl() -> String {
        return baseURL + "/search/faculties/" + endpoint
    }

    var endpoint = ""
    func search(text: String) {
        endpoint = text
        self.makeHTTPAuthenticatedGetRequest({
            json in
            let val = try! self.changeJsonToResposne(json, errorR: self.delegate)
            if (val != nil) {
                let data = val!.data;
                var array: Array<SearchElementProtocol> = Array()
                for courseSearch in data.items {
                    array.append(courseSearch)
                }
                self.delegate?.searchedItems(array)

            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }
}
