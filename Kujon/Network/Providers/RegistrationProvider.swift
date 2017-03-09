//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation




protocol RegistrationProviderProtocol: JsonParsing {

    associatedtype T = RegisterResponse
    func register(_ email: String, password:String)

}

protocol RegistrationProviderDelegate: ResponseHandlingDelegate {
    func onRegisterResponse(_ text: String)
}

class RegistrationProvider :RestApiManager,RegistrationProviderProtocol {
    weak   var delegate : RegistrationProviderDelegate! = nil

    func register(_ email: String, password: String) {
        let data = Register.createRegisterJSON(email, password: password)
        self.makeHTTPPostRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let registerResponse = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                strongSelf.delegate?.onRegisterResponse(registerResponse.data)
            }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs(text, retry: false)
        }, json: data)
    }


    override func getMyUrl() -> String {
        return baseURL + "/authentication/email_register"
    }
}
