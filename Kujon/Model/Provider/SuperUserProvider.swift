//
// Created by Wojciech Maciejewski on 26/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol SuperUserProviderProtocol: JsonProviderProtocol {
    associatedtype T = SuperUserResponse

    func loadUserDetail()


}

protocol SuperUserDetailsProviderDelegate: ErrorResponseProtocol {
    func onUserDetailLoaded(_ userDetails: SuperUserDetails)

}

class SuperUserProvider:RestApiManager,SuperUserProviderProtocol {

    weak  var delegate: SuperUserDetailsProviderDelegate!

    private var endpoint: String = "/usersinfoall"
    func loadUserDetail() {
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in

            if let user = try! self.changeJsonToResposne(json,errorR: self.delegate) {

                self.delegate?.onUserDetailLoaded(user.data)
            }
        }, onError: {[unowned self]  text in  self.delegate?.onErrorOccurs(text) })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }
}
