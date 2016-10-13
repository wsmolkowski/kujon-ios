//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
typealias onSucces = (NSData!) -> Void
typealias onErrorOccurs = (text:String) -> Void

class RestApiManager {
    static let BASE_URL: String = "https://api-demo.kujon.mobi"
//    static let BASE_URL: String = "https://api.kujon.mobi"

    private var headerManager = HeaderManager()

    var test = false
    let baseURL = BASE_URL
    var refresh = false

    func makeHTTPGetRequest(onCompletion: onSucces, onError: onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            let request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: creteCompletionHanlder(onCompletion, onError: onError))
            task.resume()
        }
        refresh = false
    }

    func makeHTTPPostRequest(onCompletion: onSucces, onError: onErrorOccurs,json:NSData) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            var request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
            let session = SessionManager.provideSession()
            request.HTTPMethod = "POST"
            request.HTTPBody = json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = session.dataTaskWithRequest(request, completionHandler: creteCompletionHanlder(onCompletion, onError: onError))
            task.resume()

        }
        refresh = false
    }

    func makeHTTPAuthenticatedPostRequest(onCompletion: onSucces, onError: onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            var request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
            let session = SessionManager.provideSession()
            request.HTTPMethod = "POST"
            self.headerManager.addHeadersToRequest(&request,refresh:refresh)
            let task = session.dataTaskWithRequest(request, completionHandler: creteCompletionHanlder(onCompletion, onError: onError))
            task.resume()

        }
        refresh = false
    }

    func makeHTTPAuthenticatedGetRequest(onCompletion: onSucces, onError: onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            if (headerManager.isAuthenticated()) {
                var request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
                let session = SessionManager.provideSession()
                self.headerManager.addHeadersToRequest(&request,refresh:refresh)
                let task = session.dataTaskWithRequest(request, completionHandler: creteCompletionHanlder(onCompletion, onError: onError))
                task.resume()
            } else {
                onError(text:StringHolder.not_auth)
            }
        }
        refresh = false
    }

    func reload(){
        var request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
        self.headerManager.addHeadersToRequest(&request)
        SessionManager.clearCacheForRequest(request)
        refresh = true
    }


    func getMyUrl() -> String {
        return baseURL
    }

    func getMyFakeJsonName() -> String!{
        return nil
    }


    private func creteCompletionHanlder(onCompletion: onSucces, onError: onErrorOccurs) -> (NSData?, NSURLResponse?, NSError?) -> Void {
        return {
            data, response, error -> Void in
            NSlogManager.showLog(String(format: "Disk cache %i of %i", NSURLCache.sharedURLCache().currentDiskUsage, NSURLCache.sharedURLCache().diskCapacity))
            NSlogManager.showLog(String(format: "Memory Cache %i of %i", NSURLCache.sharedURLCache().currentMemoryUsage, NSURLCache.sharedURLCache().memoryCapacity))
            if (error != nil) {

                dispatch_async(dispatch_get_main_queue()) {
                    onError(text:error!.localizedDescription)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    onCompletion(data!)
                }
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
        case baseURL + "/faculties":
            string = "FacultiesDetail"
        case baseURL + "/gradesbyterm":
            string = "Grades"
            break;
        case baseURL + "/courseseditionsbyterm":
            string = "Courses"

        default: string = "Usoses"
        }

        if (getMyUrl().containsString("/tt/")) {
            string = "Schedule"
        }
        if(getMyFakeJsonName() != nil){
            string = getMyFakeJsonName()
        }
        do {
            let jsonData = try JsonDataLoader.loadJson(string)
            onCompletion(jsonData)
        } catch {

        }
    }

}
