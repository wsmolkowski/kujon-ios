//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol LoginProviderProtocol {


    func login(email: String, password:String)

}
protocol LoginProviderDelegate: ErrorResponseProtocol {
    func onLoginResponse()
}
class LoginProvider:RestApiManager,RegistrationProviderProtocol {
    var delegate : LoginProviderDelegate! = nil

    func register(email: String, password: String) {
        let data = Register.createLoginJSON(email, password: password)
        self.makeHTTPPostRequest({
            delegate!.onLoginResponse()
        }, onError: {
            delegate!.onErrorOccurs("")
        }, json: data)
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_login/"
    }
}


