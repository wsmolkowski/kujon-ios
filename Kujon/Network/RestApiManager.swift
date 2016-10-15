//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
typealias onSucces = (Data!) -> Void
typealias onErrorOccurs = (_ text:String) -> Void

class RestApiManager {
//    static let BASE_URL: String = "https://api-demo.kujon.mobi"
    static let BASE_URL: String = "https://api.kujon.mobi"

    fileprivate var headerManager = HeaderManager()

    var test = false
    let baseURL = BASE_URL
    var refresh = false

    func makeHTTPGetRequest(_ onCompletion: @escaping onSucces, onError: @escaping onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            let request = URLRequest(url: URL(string: getMyUrl())!)
            let session = URLSession.shared
            let task = session.dataTask(with: request) {
                data, response, error in
                NSlogManager.showLog(String(format: "Disk cache %i of %i", URLCache.shared.currentDiskUsage, URLCache.shared.diskCapacity))
                NSlogManager.showLog(String(format: "Memory Cache %i of %i", URLCache.shared.currentMemoryUsage, URLCache.shared.memoryCapacity))
                if let error = error {
                    DispatchQueue.main.async {
                        onError(error.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        onCompletion(data!)
                    }
                }
            }

            task.resume()
        }
        refresh = false
    }

    func makeHTTPPostRequest(_ onCompletion: @escaping onSucces, onError: @escaping onErrorOccurs,json:Data) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            var request = URLRequest(url: URL(string: getMyUrl())!)
            let session = SessionManager.provideSession()
            request.httpMethod = "POST"
            request.httpBody = json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = session.dataTask(with: request) {
                data, response, error in
                NSlogManager.showLog(String(format: "Disk cache %i of %i", URLCache.shared.currentDiskUsage, URLCache.shared.diskCapacity))
                NSlogManager.showLog(String(format: "Memory Cache %i of %i", URLCache.shared.currentMemoryUsage, URLCache.shared.memoryCapacity))
                if let error = error {
                    DispatchQueue.main.async {
                        onError(error.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        onCompletion(data!)
                    }
                }
            }

            task.resume()

        }
        refresh = false
    }

    func makeHTTPAuthenticatedPostRequest(_ onCompletion: @escaping onSucces, onError: @escaping onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            var request = URLRequest(url: URL(string: getMyUrl())!)
            let session = SessionManager.provideSession()
            request.httpMethod = "POST"
            self.headerManager.addHeadersToRequest(&request,refresh:refresh)
            let task = session.dataTask(with: request) {
                data, response, error in
                NSlogManager.showLog(String(format: "Disk cache %i of %i", URLCache.shared.currentDiskUsage, URLCache.shared.diskCapacity))
                NSlogManager.showLog(String(format: "Memory Cache %i of %i", URLCache.shared.currentMemoryUsage, URLCache.shared.memoryCapacity))
                if let error = error {
                    DispatchQueue.main.async {
                        onError(error.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        onCompletion(data!)
                    }
                }
            }

            task.resume()

        }
        refresh = false
    }

    func makeHTTPAuthenticatedGetRequest(_ onCompletion: @escaping onSucces, onError: @escaping onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            if (headerManager.isAuthenticated()) {
                var request = URLRequest(url: URL(string: getMyUrl())!)
                let session = SessionManager.provideSession()
                self.headerManager.addHeadersToRequest(&request,refresh:refresh)
                let task = session.dataTask(with: request) {
                    data, response, error in
                    NSlogManager.showLog(String(format: "Disk cache %i of %i", URLCache.shared.currentDiskUsage, URLCache.shared.diskCapacity))
                    NSlogManager.showLog(String(format: "Memory Cache %i of %i", URLCache.shared.currentMemoryUsage, URLCache.shared.memoryCapacity))
                    if let error = error {
                        DispatchQueue.main.async {
                            onError(error.localizedDescription)
                        }
                    } else {
                        DispatchQueue.main.async {
                            onCompletion(data!)
                        }
                    }
                }

                task.resume()
            } else {
                onError(StringHolder.not_auth)
            }
        }
        refresh = false
    }

    func reload(){
        var request = URLRequest(url: URL(string: getMyUrl())!)
        self.headerManager.addHeadersToRequest(&request)
        SessionManager.clearCacheForRequest(request as URLRequest)
        refresh = true
    }


    func getMyUrl() -> String {
        return baseURL
    }

    func getMyFakeJsonName() -> String!{
        return nil
    }


    fileprivate func createCompletionHanlder(_ onCompletion: @escaping onSucces, onError: @escaping onErrorOccurs) -> (Data?, URLResponse?, NSError?) -> Void {
        return {
            data, response, error in
            NSlogManager.showLog(String(format: "Disk cache %i of %i", URLCache.shared.currentDiskUsage, URLCache.shared.diskCapacity))
            NSlogManager.showLog(String(format: "Memory Cache %i of %i", URLCache.shared.currentMemoryUsage, URLCache.shared.memoryCapacity))
            if let error = error {
                DispatchQueue.main.async {
                    onError(error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    onCompletion(data!)
                }
            }
        }
    }


    fileprivate func handelTestCase(_ onCompletion: onSucces) {
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

        if (getMyUrl().contains("/tt/")) {
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
