//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class HeaderManager {

    private var userDataHolder = UserDataHolder.sharedInstance

    private let EMAIL_HEADER = "X-Kujonmobiemail"
    private let TOKEN_HEADER = "X-Kujonmobitoken"
    func isAuthenticated()->Bool{
        return (userDataHolder.userEmail != nil) && (userDataHolder.userToken != nil)
    }
    func addHeadersToRequest(inout request: NSMutableURLRequest) {
        request.addValue(userDataHolder.userEmail, forHTTPHeaderField: EMAIL_HEADER)
        request.addValue(userDataHolder.userToken, forHTTPHeaderField: TOKEN_HEADER)
    }
}
