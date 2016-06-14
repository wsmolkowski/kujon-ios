//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

typealias onSucces = (NSData!) -> Void
typealias onErrorOccurs = () -> Void

class RestApiManager {

     var test = false
    let baseURL = "https://api.kujon.mobi"
    var specificUrl = ""

    func makeHTTPGetRequest(onCompletion: onSucces, onError: onErrorOccurs) {
        if (test) {
            self.handelTestCase(onCompletion)
        } else {
            let request = NSMutableURLRequest(URL: NSURL(string: getMyUrl())!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler:creteCompletionHanlder(onCompletion,onError: onError))
            task.resume()
        }
    }

    func getMyUrl() -> String {
        return baseURL
    }

    private func creteCompletionHanlder(onCompletion: onSucces, onError: onErrorOccurs)-> (NSData?, NSURLResponse?, NSError?) -> Void{
        return {
            data, response, error -> Void in
            if(error != nil){
                onError()
            }else {
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
        default: string = "Usoses"
        }
        do {
            let jsonData = try  JsonDataLoader.loadJson(string)
            onCompletion(jsonData)
        } catch {

        }
    }


}
