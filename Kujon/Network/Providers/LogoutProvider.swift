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
    weak var delegate: LogoutProviderDelegate! = nil


    func logout() {
        UserDataHolder.sharedInstance.userUsosImage = nil

        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in

            self.delegate?.onSuccesfullLogout()

        }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/logout"
    }

}
