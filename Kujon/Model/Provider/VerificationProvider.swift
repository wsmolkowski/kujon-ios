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
    func onVerificationSuccess(_ data: Data)
}

class VerificationProvider: RestApiManager, VerificationProviderProtocol {

    weak var delegate: VerificationProviderDelegate?
    private var headerManager = HeaderManager()

    func verify(URLString: String) {

        addStoredCookies = true

        makeHTTPAuthenticatedGetRequest({ [weak self] (data) in
            self?.delegate?.onVerificationSuccess(data)
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs(text)
        })

    }

}
