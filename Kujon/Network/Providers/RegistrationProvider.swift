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
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let registerResponse = try! strongSelf.changeJsonToResposne(json, errorR: strongSelf.delegate) {
                strongSelf.delegate?.onRegisterResponse(registerResponse.data)
            }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs(text)
        }, json: data)
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_register"
    }
}
