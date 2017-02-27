//
// Created by Wojciech Maciejewski on 07/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol DeleteAccountProviderProtocol {
    func deleteAccount()
}

protocol DeleteAccountProviderDelegate: ErrorResponseProtocol {

    func accountDeleted()

}

class DeleteAccountProvider: RestApiManager, DeleteAccountProviderProtocol {
    weak var delegate: DeleteAccountProviderDelegate! = nil
    func deleteAccount() {
        self.makeHTTPAuthenticatedPostRequest({
            [weak self] data in
            self?.delegate?.accountDeleted()
            SessionManager.clearCache()
        }, onError: {
            [weak self] text in
            self?.delegate.onErrorOccurs()
        })
    }


    var endpoint: String! = nil
    override func getMyUrl() -> String {
        return baseURL + "/authentication/archive"
    }

}
