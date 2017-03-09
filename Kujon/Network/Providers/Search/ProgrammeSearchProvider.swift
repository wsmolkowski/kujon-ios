//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol ProgrammeSearchProtocol: JsonParsing {
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
                self.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            if let val  = try! self.parseResposne(json, errorHandler: self.delegate) {
                self.delegate?.searchedItems(self.getSearchElements(val))
                self.delegate?.isThereNextPage(self.isThereNext(val));
            }
        }, onError: { [weak self] text in
            self?.delegate?.onErrorOccurs(text, retry: false)
        })
    }


}
