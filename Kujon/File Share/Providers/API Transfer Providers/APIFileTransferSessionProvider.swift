//
//  APIFileTransferSessionProvider.swift
//  Kujon
//
//  Created by Adam on 22.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class APIFileTransferSessionProvider {

    // Attention: single session cannot handle simultaneous uploads and donwloads

    internal static func downloadsSession(delegate: URLSessionTaskDelegate) -> URLSession {
        let configuration = APIFileTransferSessionProvider.deafultSesionConfiguration()
        let session = URLSession(configuration:configuration, delegate: delegate, delegateQueue: nil)
        return session
    }

    internal static func uploadsSession(delegate: URLSessionTaskDelegate) -> URLSession {
        let configuration = APIFileTransferSessionProvider.deafultSesionConfiguration()
        let session = URLSession(configuration:configuration, delegate: delegate, delegateQueue: nil)
        return session
    }

    static func deafultSesionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.timeoutIntervalForRequest = 180
        configuration.httpMaximumConnectionsPerHost = 6
        configuration.allowsCellularAccess = true
        configuration.httpShouldSetCookies = false
        return configuration
    }

}
