//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol LoginProviderProtocol:JsonProviderProtocol {
    associatedtype T = LoginResponse

    func login(email: String, password:String)

}
protocol LoginProviderDelegate: ErrorResponseProtocol {
    func onLoginResponse(token: String)
}
class LoginProvider:RestApiManager,LoginProviderProtocol {
    weak var delegate : LoginProviderDelegate! = nil


    func login(email: String, password: String) {
        let data = Register.createLoginJSON(email, password: password)

        self.makeHTTPPostRequest({
            json in
            if let loginResponse = try! self.changeJsonToResposne(json,errorR: self.delegate){
                self.delegate?.onLoginResponse(loginResponse.data.token)
            }

        }, onError: {
            text in
            self.delegate!.onErrorOccurs(text)
        }, json: data)

    }




    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_login"
    }
}


