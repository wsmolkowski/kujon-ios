//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol CoursesSearchProtocol: JsonProviderProtocol {
    associatedtype T = CourseSearchResponse


}


class CoursesSearchProvider: RestApiManager, CoursesSearchProtocol, SearchProviderProtocol {

    var delegate: SearchProviderDelegate!

    func search(text: String) {

        self.makeHTTPAuthenticatedGetRequest({
            json in
            if let coursesSearch = try! self.changeJsonToResposne(json, errorR: self.delegate) {
                let data = coursesSearch.data;
                var array:Array<SearchElementProtocol>  = Array()
                for courseSearch in data.items{
                    array.append(courseSearch)
                }
                                     self.delegate?.searchedItems(array)
//
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }
}



