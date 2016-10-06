//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol CoursesSearchProtocol: JsonProviderProtocol {
    associatedtype T = CourseSearchResponse


}


class CoursesSearchProvider: RestApiManager, CoursesSearchProtocol, SearchProviderProtocol {

    weak var delegate: SearchProviderDelegate!
    func setDelegate(delegate: SearchProviderDelegate) {
        self.delegate = delegate
    }

    override func getMyUrl() -> String {
        return baseURL + "/search/courses/" + endpoint
    }

    var endpoint = ""
    func search(text: String, more: Int) {
        endpoint = text + "?start=" + String(more)
        self.makeHTTPAuthenticatedGetRequest({
            json in
            let val  = try! self.changeJsonToResposne(json, errorR: self.delegate)
            if (val != nil) {
                let data = val!.data;
                var array: Array<SearchElementProtocol> = Array()
                for courseSearch in data.items {
                    array.append(courseSearch)
                }
                self.delegate?.searchedItems(array)
//
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }
}



