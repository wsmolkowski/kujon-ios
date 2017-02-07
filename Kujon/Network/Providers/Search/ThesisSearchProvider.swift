//
// Created by Wojciech Maciejewski on 09/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ThesisSearchProtocol: JsonProviderProtocol {
    associatedtype T = TheseSearchResponse


}

class ThesisSearchProvider: RestApiManager, ThesisSearchProtocol, SearchProviderProtocol {


    weak var delegate: SearchProviderDelegate!

    func setDelegate(_ delegate: SearchProviderDelegate) {
        self.delegate = delegate
    }

    override func getMyUrl() -> String {
        return baseURL + "/search/theses/" + endpoint
    }

    var endpoint = ""

    func search(_ text: String, more: Int) {

        endpoint = text + "?start=" + String(more)
        self.makeHTTPAuthenticatedGetRequest({
            json in
            let val = try! self.changeJsonToResposne(json, errorR: self.delegate)
            if let val = val {

                self.delegate?.searchedItems(self.getSearchElements(val))
                self.delegate?.isThereNextPage(self.isThereNext(val));
            }
        }, onError: { text in self.delegate?.onErrorOccurs(text) })
    }

}