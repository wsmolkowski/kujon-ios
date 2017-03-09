//
// Created by Wojciech Maciejewski on 26/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol SuperUserProviderProtocol: JsonParsing {
    associatedtype T = SuperUserResponse

    func loadUserDetail()


}

protocol SuperUserDetailsProviderDelegate: ResponseHandlingDelegate {
    func onUserDetailLoaded(_ userDetails: SuperUserDetails)

}

class SuperUserProvider:RestApiManager,SuperUserProviderProtocol {

    weak  var delegate: SuperUserDetailsProviderDelegate!

    private var endpoint: String = "/usersinfoall"
    func loadUserDetail() {
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let user = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                strongSelf.delegate?.onUserDetailLoaded(user.data)
            }
        }, onError: {[weak self]
            text in
            self?.delegate?.onErrorOccurs(text, retry: false)
        })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }
}
