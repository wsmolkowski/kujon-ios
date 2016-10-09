//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
protocol SearchProviderProtocol {
    func search(text: String, more: Int)
    func setDelegate(delegate: SearchProviderDelegate)
}

extension SearchProviderProtocol{
    func getSearchElements(getList: GetListOfSearchElements)->Array<SearchElementProtocol>{
        return getList.getList()
    }
    func isThereNext(getList: GetListOfSearchElements) -> Bool{
        return getList.isThereNext()
    }
}




protocol SearchProviderDelegate: ErrorResponseProtocol {
    func searchedItems(array: Array<SearchElementProtocol>)
    func isThereNextPage(isThere:Bool)

}

enum SearchTypes {
    case courses
    case students
    case facultie
    case programme
    case thesis
}



