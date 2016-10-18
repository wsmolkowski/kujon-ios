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
    func changeJsonToResposne(_ jsonData: Data, errorR: ErrorResponseProtocol!) throws -> T! {
        do {
//            NSlogManager.showLog(NSString(data:jsonData, encoding:NSUTF8StringEncoding) as! String)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return try T.decode(json)
        } catch {
            SessionManager.clearCache()
            NSlogManager.showLog("JSON serialization failed:  \(error)")

            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                let errora = try ErrorClass.decode(json)
                if (errora.code != nil && errorR != nil) {
                    switchOverCodes(errora.code!, text: errora.message, errorR: errorR!)
                }else if(errora.code == nil){
                    errorR.onErrorOccurs(errora.message)
                }
                return nil
            } catch {
                if (errorR != nil) {
                    errorR.onErrorOccurs(StringHolder.errorOccures)
                }
                return nil
            }
        }
    }

    fileprivate func switchOverCodes(_ code: Int, text: String, errorR: ErrorResponseProtocol) {
        switch code {
        case 401:
            errorR.unauthorized(text)
            break;
        default:
            errorR.onErrorOccurs(text)
            break;
        }
    }
}

