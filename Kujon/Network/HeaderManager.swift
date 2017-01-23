//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class HeaderManager {

    private var userDataHolder = UserDataHolder.sharedInstance

    private let EMAIL_HEADER = "X-Kujonmobiemail"
    private let TOKEN_HEADER = "X-Kujonmobitoken"
    private let REFRESH_TOKEN = "X-Kujonrefresh"
    private let COOKIE_HEADER = "Cookie"

    func isAuthenticated()->Bool{
        return (userDataHolder.userEmail != nil) && (userDataHolder.userToken != nil)
    }

    func addHeadersToRequest(_ request: inout URLRequest, refresh:Bool = false, addStoredCookies:Bool = false) {
        request.addValue(userDataHolder.userEmail ?? "", forHTTPHeaderField: EMAIL_HEADER)
        request.addValue(userDataHolder.userToken ?? "", forHTTPHeaderField: TOKEN_HEADER)

        if(refresh){
            request.addValue("true", forHTTPHeaderField: REFRESH_TOKEN)
        }

        if addStoredCookies {
            let cookies = retrieveCookies()
            request.addValue(cookies, forHTTPHeaderField: COOKIE_HEADER)
        }
    }

    func addRefreshToken(_ request: inout URLRequest, refresh:Bool = false){
        if(refresh){
            request.addValue("true", forHTTPHeaderField: REFRESH_TOKEN)
        }
    }

    private func retrieveCookies() -> String {
        var result: String = ""
        guard let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: RestApiManager.BASE_URL)!) else {
            return result
        }
        cookies.forEach {
            result += ($0 as HTTPCookie).name + "=" + ($0 as HTTPCookie).value + ";"
        }
        return result
    }

}
