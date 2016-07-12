//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ErrorResponseProtocol {
    func onErrorOccurs(text:String)
}


extension ErrorResponseProtocol{
    func onErrorOccurs(text: String = "") {
    }

}