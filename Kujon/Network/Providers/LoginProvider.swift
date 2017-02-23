//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol LoginProviderProtocol:JsonProviderProtocol {
    associatedtype T = LoginResponse

    func login(_ email: String, password:String)

}
protocol LoginProviderDelegate: ErrorResponseProtocol {
    func onLoginResponse(_ token: String)
}
class LoginProvider:RestApiManager,LoginProviderProtocol {
    weak var delegate : LoginProviderDelegate! = nil


    func login(_ email: String, password: String) {
        let data = Register.createLoginJSON(email, password: password)

        self.makeHTTPPostRequest({
            [unowned self] json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let loginResponse = try? self.changeJsonToResposne(json,errorR: self.delegate){
                self.delegate?.onLoginResponse(loginResponse.data.token)
            }

        }, onError: {
            [unowned self] text in
            self.delegate!.onErrorOccurs(text)
        }, json: data)

    }




    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_login"
    }
}


