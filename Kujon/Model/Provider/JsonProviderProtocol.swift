//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

protocol JsonProviderProtocol {
    associatedtype T:Decodable

}
extension JsonProviderProtocol{
     func changeJsonToResposne(jsonData:NSData,onError myError: (message:String)->Void) throws ->T! {
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            NSlogManager.showLog(NSString(data:jsonData, encoding:NSUTF8StringEncoding) as! String)
            return try T.decode(json)
        }catch {
            SessionManager.clearCache()
            NSlogManager.showLog("JSON serialization failed:  \(error)")
            myError(message: "Nie ma takich danych")
            return nil
        }
    }
}