//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

protocol JsonProviderProtocol {
    associatedtype T: Decodable

}

extension JsonProviderProtocol {
    func changeJsonToResposne(jsonData: NSData, errorR: ErrorResponseProtocol!) throws -> T! {
        do {
//            NSlogManager.showLog(NSString(data:jsonData, encoding:NSUTF8StringEncoding) as! String)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            return try T.decode(json)
        } catch {
            NSlogManager.showLog(NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String)
            SessionManager.clearCache()
            NSlogManager.showLog("JSON serialization failed:  \(error)")

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                let error = try ErrorClass.decode(json)
                if(errorR != nil){

                    errorR.onErrorOccurs(error.message)
                }
                return nil
            } catch {
                if(errorR != nil) {
                    errorR.onErrorOccurs(StringHolder.errorOccures)
                }
                return nil
            }
        }
    }
}