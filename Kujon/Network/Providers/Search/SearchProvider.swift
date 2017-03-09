//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
protocol SearchProviderProtocol {
    func search(_ text: String, more: Int)
    func setDelegate(_ delegate: SearchProviderDelegate)
}

extension SearchProviderProtocol{
    func getSearchElements(_ getList: GetListOfSearchElements)->Array<SearchElementProtocol>{
        return getList.getList()
    }
    func isThereNext(_ getList: GetListOfSearchElements) -> Bool{
        return getList.isThereNext()
    }
}




protocol SearchProviderDelegate: ErrorHandlingDelegate {
    func searchedItems(_ array: Array<SearchElementProtocol>)
    func isThereNextPage(_ isThere:Bool)

}

enum SearchTypes {
    case courses
    case students
    case facultie
    case programme
    case thesis
}



