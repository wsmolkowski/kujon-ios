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
    func setDelegate(_ delegate: SearchProviderDelegate) {
        self.delegate = delegate
    }

    override func getMyUrl() -> String {
        return baseURL + "/search/programmes/" + endpoint
    }

    var endpoint = ""
    func search(_ text: String, more: Int) {
        endpoint = text + "?start=" + String(more)
        self.makeHTTPAuthenticatedGetRequest({
            json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let val  = try! self.changeJsonToResposne(json, errorR: self.delegate) {
                self.delegate?.searchedItems(self.getSearchElements(val))
                self.delegate?.isThereNextPage(self.isThereNext(val));
            }
        }, onError: { text in self.delegate?.onErrorOccurs(text) })
    }


}
