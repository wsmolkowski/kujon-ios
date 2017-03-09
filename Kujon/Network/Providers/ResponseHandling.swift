//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ResponseHandlingDelegate: Unauthorized {

    func onErrorOccurs(_ text:String, retry: Bool)
    func onErrorOccurs()
    func onUsosDown()
}


extension ResponseHandlingDelegate {

    func onErrorOccurs() { }
    func onUsosDown() { }

}
