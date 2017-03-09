//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

protocol JsonParsing {
    associatedtype T: Decodable

}

extension JsonParsing {
    
    func parseResposne(_ jsonData: Data, errorHandler delegate: ResponseHandlingDelegate!) throws -> T! {
        do {

            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return try T.decode(json)

        } catch {
            SessionManager.clearCache()
            NSlogManager.showLog("JSON serialization failed:  \(error)")

            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                let errorResponse = try ErrorResponse.decode(json)
                if (errorResponse.code != nil && delegate != nil) {
                    handleErrorResponseCode(errorResponse.code!, text: errorResponse.message, errorHandler: delegate!)
                }else if(errorResponse.code == nil){
                    delegate.onErrorOccurs(errorResponse.message, retry: false)
                }
                return nil
            } catch {
                delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return nil
            }
        }
    }

    private func handleErrorResponseCode(_ code: Int, text: String, errorHandler delegate: ResponseHandlingDelegate) {
        switch code {
        case 401:
            if delegate is LoginProviderDelegate {
                delegate.onErrorOccurs(text, retry: false)
            } else {
                delegate.unauthorized(text)
            }
        case 400:
            if UserLoginEnum.getLoginType() == .google {
                GIDSignIn.sharedInstance().signInSilently()
                delegate.onErrorOccurs(text, retry: true)
            } else {
                delegate.onErrorOccurs(text, retry: false)
            }
        case 504:
            delegate.onUsosDown()
        case 524:
            delegate.onErrorOccurs(StringHolder.timeoutMessage, retry: false)
        default:
            delegate.onErrorOccurs(text, retry: false)
        }
    }
}

