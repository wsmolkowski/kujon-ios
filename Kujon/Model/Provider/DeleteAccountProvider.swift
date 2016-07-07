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
class DeleteAccountProvider:RestApiManager,DeleteAccountProviderProtocol {
    var delegate :DeleteAccountProviderDelegate! = nil
    func deleteAccount() {
        self.makeHTTPAuthenticatedGetRequest({data in
        self.delegate?.accountDeleted()
        },onError: {
            self.delegate.onErrorOccurs()
        })
    }


    var endpoint: String! = nil
    override func getMyUrl() -> String {
        return baseURL + "/authentication/archive"
    }

}