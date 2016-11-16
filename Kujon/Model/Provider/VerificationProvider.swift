//
//  VerificationProvider.swift
//  Kujon
//
//  Created by Adam on 15.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol VerificationProviderProtocol {
    func verify(URLString: String)
}


protocol VerificationProviderDelegate: ErrorResponseProtocol {
    func onVerificationResponse(result: VerificationResult)
}


enum VerificationResult {
    case success
    case error(String)
    case unidentifiedResponseError
    case serializationError
}


class VerificationProvider: RestApiManager, VerificationProviderProtocol {

    internal weak var delegate: VerificationProviderDelegate?

    internal var verificationRequirement: String {
        return String(format: "%@/authentication/verify", RestApiManager.BASE_URL)
    }

    internal func verify(URLString: String) {
        addStoredCookies = true
        makeHTTPAuthenticatedGetRequest({ [weak self] (data) in

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                self?.delegate?.onVerificationResponse(result:.serializationError)
                return
            }

            if let _ = try? UsosPaired.decode(json) {
                self?.delegate?.onVerificationResponse(result:.success)
                return
            }

            if let error = try? ErrorClass.decode(json) {
                self?.delegate?.onVerificationResponse(result:.error(error.message))
                return
            }

            self?.delegate?.onVerificationResponse(result:.unidentifiedResponseError)

        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs(text)
        })
    }

    override func getMyUrl() -> String {
        let userDataHolder = UserDataHolder.sharedInstance
        return String(format: "%@/authentication/register?email=%@&token=%@&usos_id=%@&type=%@", RestApiManager.BASE_URL, userDataHolder.userEmail, userDataHolder.userToken, userDataHolder.usosId, userDataHolder.userLoginType)
    }

}
