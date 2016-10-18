//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class HeaderManager {

    fileprivate var userDataHolder = UserDataHolder.sharedInstance

    fileprivate let EMAIL_HEADER = "X-Kujonmobiemail"
    fileprivate let TOKEN_HEADER = "X-Kujonmobitoken"
    fileprivate let REFRESH_TOKEN = "X-Kujonrefresh"
    func isAuthenticated()->Bool{
        return (userDataHolder.userEmail != nil) && (userDataHolder.userToken != nil)
    }
    func addHeadersToRequest(_ request: inout URLRequest, refresh:Bool = false) {
        request.addValue(userDataHolder.userEmail, forHTTPHeaderField: EMAIL_HEADER)
        request.addValue(userDataHolder.userToken, forHTTPHeaderField: TOKEN_HEADER)
        if(refresh){
            request.addValue("true", forHTTPHeaderField: REFRESH_TOKEN)
        }
    }
}
