//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol UsersSearchProtocol: JsonProviderProtocol {
    associatedtype T = UserSearchResponse


}


class UserSearchProvider : RestApiManager, UsersSearchProtocol, SearchProviderProtocol {

    var delegate: SearchProviderDelegate!

    func search(text: String) {

        self.makeHTTPAuthenticatedGetRequest({
            json in
            if let userSearch = try! self.changeJsonToResposne(json, errorR: self.delegate) {
                let data = userSearch.data;
                var array:Array<SearchElementProtocol>  = Array()
                for userSearch in data.items{
                    array.append(userSearch)
                }
                self.delegate?.searchedItems(array)
//
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }
}