//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class SessionManager {


    static func provideSession() -> URLSession {
        let conf = URLSessionConfiguration.default
        conf.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        return URLSession(configuration: conf)
    }
    static func setCache(){
        let URLCache = Foundation.URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        Foundation.URLCache.setSharedURLCache(URLCache)
    }

    static func clearCache(){
        URLCache.shared.removeAllCachedResponses()
        setCache()
    }

    static func clearCacheForRequest(_ request : URLRequest){
//        NSURLCache.sharedURLCache().removeCachedResponseForRequest( request)// this does not work, need to clear all
        URLCache.shared.removeAllCachedResponses()
        setCache()
    }
}
