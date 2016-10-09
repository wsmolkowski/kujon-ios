//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol ProgrammeSearchProtocol: JsonProviderProtocol {
    associatedtype T = ProgrammeSearchResponse


}


class ProgrammeSearchProvider:RestApiManager,ProgrammeSearchProtocol,SearchProviderProtocol {


    weak var delegate: SearchProviderDelegate!
    func setDelegate(delegate: SearchProviderDelegate) {
        self.delegate = delegate
    }

    override func getMyUrl() -> String {
        return baseURL + "/search/programmes/" + endpoint
    }

    var endpoint = ""
    func search(text: String, more: Int) {
        endpoint = text + "?start=" + String(more)
        self.makeHTTPAuthenticatedGetRequest({
            json in
            let val  = try! self.changeJsonToResposne(json, errorR: self.delegate)
            if (val != nil) {
                self.delegate?.searchedItems(self.getSearchElements(val))
                self.delegate?.isThereNextPage(self.isThereNext(val));
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }


}
