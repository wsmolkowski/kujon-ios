//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol RegistrationProviderProtocol {


    func register(email: String, password:String)

}

protocol RegistrationProviderDelegate: ErrorResponseProtocol {
    func onRegisterResponse()
}

class RegistrationProvider :RestApiManager,RegistrationProviderProtocol {
    var delegate : RegistrationProviderDelegate! = nil

    func register(email: String, password: String) {
        let data = Register.createRegisterJSON(email, password: password)
        self.makeHTTPPostRequest({
            delegate!.onRegisterResponse()
        }, onError: {
            delegate!.onErrorOccurs("")
        }, json: data)
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_register/"
    }
}
