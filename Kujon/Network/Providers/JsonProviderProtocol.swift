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

    private func switchOverCodes(_ code: Int, text: String, errorR: ErrorResponseProtocol) {
        switch code {
        case 401:
            if errorR is LoginProviderDelegate {
                errorR.onErrorOccurs(text)
            } else {
                errorR.unauthorized(text)
            }
        case 400:
            if UserLoginEnum.getLoginType() == .google {
                GIDSignIn.sharedInstance().signInSilently()
                errorR.onErrorOccurs(text, retry: true)
            } else {
                errorR.onErrorOccurs(text)
            }
        case 504:
            errorR.onUsosDown()
        case 524:
            errorR.onErrorOccurs(StringHolder.timeoutMessage)
        default:
            errorR.onErrorOccurs(text)
        }
    }
}

