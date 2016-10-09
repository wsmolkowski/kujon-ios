//
// Created by Wojciech Maciejewski on 09/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol GetListOfSearchElements {
    func isThereNext()-> Bool
    func getList()-> Array<SearchElementProtocol>
}
