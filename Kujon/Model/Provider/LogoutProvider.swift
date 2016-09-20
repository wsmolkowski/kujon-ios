//
// Created by Wojciech Maciejewski on 20/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LogoutProviderProtocol {
    func logout()
}

protocol LogoutProviderDelegate: ErrorResponseProtocol {
    func onSuccesfullLogout();
}

class LogoutProvider: RestApiManager, LogoutProviderProtocol {
    var delegate: LogoutProviderDelegate! = nil


    func logout() {

        self.makeHTTPAuthenticatedGetRequest({
            json in

            self.delegate?.onSuccesfullLogout()

        }, onError: { text in self.delegate?.onErrorOccurs() })
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/logout"
    }

}
