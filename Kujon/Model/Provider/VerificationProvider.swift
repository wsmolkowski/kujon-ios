//
//  VerificationProvider.swift
//  Kujon
//
//  Created by Adam on 15.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol VerificationProviderProtocol: JsonProviderProtocol {
    associatedtype T = UsosPaired
    func verify(URLString: String)
}


protocol VerificationProviderDelegate: ErrorResponseProtocol {
    func onVerificationSuccess()
}


class VerificationProvider: RestApiManager, VerificationProviderProtocol {

    internal weak var delegate: VerificationProviderDelegate?

    internal var verificationRequirement: String {
        return String(format: "%@/authentication/verify", RestApiManager.BASE_URL)
    }

    internal func verify(URLString: String) {
        addStoredCookies = true
        makeHTTPAuthenticatedGetRequest({ [unowned self] data in

            if let _ = try? self.changeJsonToResposne(data, errorR: self.delegate){
                self.delegate?.onVerificationSuccess()
            }

        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs(text)
        })
    }

    override func getMyUrl() -> String {
        let userDataHolder = UserDataHolder.sharedInstance
        return String(format: "%@/authentication/register?email=%@&token=%@&usos_id=%@&type=%@", RestApiManager.BASE_URL, userDataHolder.userEmail, userDataHolder.userToken, userDataHolder.usosId, userDataHolder.userLoginType)
    }

}
