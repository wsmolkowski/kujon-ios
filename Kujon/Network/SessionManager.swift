//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class SessionManager {


    static func provideSession() -> NSURLSession {
        var conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        conf.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        return NSURLSession(configuration: conf)
    }
    static func setCache(){
        let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)
    }
}