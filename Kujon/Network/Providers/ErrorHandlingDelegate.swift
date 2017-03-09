//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ErrorHandlingDelegate: Unauthorized {

    func onErrorOccurs(_ text:String, retry: Bool)
    func onErrorOccurs()
    func onUsosDown()
}


extension ErrorHandlingDelegate {

    func onErrorOccurs() { }
    func onUsosDown() { }

}
