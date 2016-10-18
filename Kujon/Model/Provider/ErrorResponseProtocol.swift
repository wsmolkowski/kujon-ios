//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ErrorResponseProtocol: Unauthorized {
    func onErrorOccurs(_ text:String)
}


extension ErrorResponseProtocol{
    func onErrorOccurs(_ text: String = "") {
    }

}
