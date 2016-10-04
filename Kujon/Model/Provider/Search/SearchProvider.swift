//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
protocol SearchProviderProtocol {
    func search(text: String)
    func setDelegate(delegate: SearchProviderDelegate)
}





protocol SearchProviderDelegate: ErrorResponseProtocol {
    func searchedItems(array: Array<SearchElementProtocol>)
}

enum SearchTypes {
    case courses
    case students
    case facultie
    case programme
    case thesis
}



