//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol RegistrationProviderProtocol:JsonProviderProtocol {

    associatedtype T = RegisterResponse
    func register(email: String, password:String)

}

protocol RegistrationProviderDelegate: ErrorResponseProtocol {
    func onRegisterResponse(text: String)
}

class RegistrationProvider :RestApiManager,RegistrationProviderProtocol {
    var delegate : RegistrationProviderDelegate! = nil

    func register(email: String, password: String) {
        let data = Register.createRegisterJSON(email, password: password)
        self.makeHTTPPostRequest({

            json in
            if let registerResponse = try! self.changeJsonToResposne(json, onError: {
                text in
                self.delegate?.onErrorOccurs(text)
            }) {
                self.delegate?.onRegisterResponse(registerResponse.data)
            }
        }, onError: { text in
            self.delegate!.onErrorOccurs(text)
        }, json: data)
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_register"
    }
}
