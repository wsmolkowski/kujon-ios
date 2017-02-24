//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol RegistrationProviderProtocol:JsonProviderProtocol {

    associatedtype T = RegisterResponse
    func register(_ email: String, password:String)

}

protocol RegistrationProviderDelegate: ErrorResponseProtocol {
    func onRegisterResponse(_ text: String)
}

class RegistrationProvider :RestApiManager,RegistrationProviderProtocol {
    weak   var delegate : RegistrationProviderDelegate! = nil

    func register(_ email: String, password: String) {
        let data = Register.createRegisterJSON(email, password: password)
        self.makeHTTPPostRequest({
            [unowned self] json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let registerResponse = try! self.changeJsonToResposne(json, errorR: self.delegate) {
                self.delegate?.onRegisterResponse(registerResponse.data)
            }
        }, onError: {[unowned self] text in
            self.delegate!.onErrorOccurs(text)
        }, json: data)
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_register"
    }
}
