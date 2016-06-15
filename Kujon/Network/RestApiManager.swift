//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

typealias onSucces = (NSData!) -> Void
typealias onErrorOccurs = () -> Void

class RestApiManager {
    static let BASE_URL: String = "https://api.kujon.mobi"
    private let EMAIL_HEADER = "X-Kujonmobiemail"
    private let TOKEN_HEADER = "X-Kujonmobitoken"
    private var userDataHolder = UserDataHolder.sharedInstance

    var test = false
    let baseURL = BASE_URL

    func makeHTTPGetRequest(onCompletion: onSucces, onError: onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            let request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: creteCompletionHanlder(onCompletion, onError: onError))
            task.resume()
        }
    }

    func makeHTTPAuthenticatedGetRequest(onCompletion: onSucces, onError: onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            if (userDataHolder.loggedToUsosForCurrentEmail) {
                var request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
                let session = NSURLSession.sharedSession()
                self.addHeadersToRequest(&request)
                let task = session.dataTaskWithRequest(request, completionHandler: creteCompletionHanlder(onCompletion, onError: onError))
                task.resume()
            } else {
                onError()
            }
        }
    }

    func getMyUrl() -> String {
        return baseURL
    }

    private func addHeadersToRequest(inout request: NSMutableURLRequest) {
        request.addValue(userDataHolder.userEmail, forHTTPHeaderField: EMAIL_HEADER)
        request.addValue(userDataHolder.userToken, forHTTPHeaderField: TOKEN_HEADER)
    }

    private func creteCompletionHanlder(onCompletion: onSucces, onError: onErrorOccurs) -> (NSData?, NSURLResponse?, NSError?) -> Void {
        return {
            data, response, error -> Void in
            if (error != nil) {
                onError()
            } else {
                onCompletion(data!)
            }
        }
    }


    private func handelTestCase(onCompletion: onSucces) {
        var string: String
        switch (getMyUrl()) {
        case baseURL + "/usoses":
            string = "Usoses"
            break;
        case baseURL + "/users":
            string = "User"
            break;
        case baseURL + "/lecturers":
            string = "Lecturers"
            break;
        default: string = "Usoses"
        }
        do {
            let jsonData = try JsonDataLoader.loadJson(string)
            onCompletion(jsonData)
        } catch {

        }
    }


}
