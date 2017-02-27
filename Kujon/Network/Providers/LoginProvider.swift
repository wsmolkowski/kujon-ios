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
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let loginResponse = try! strongSelf.changeJsonToResposne(json,errorR: strongSelf.delegate){
                strongSelf.delegate?.onLoginResponse(loginResponse.data.token)
            }

        }, onError: {
            [weak self] text in
            self?.delegate!.onErrorOccurs(text)
        }, json: data)

    }




    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_login"
    }
}


