//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol UserDetailsProviderProtocol: JsonProviderProtocol {
    associatedtype T = UserDetailsResponse

    func loadUserDetail()

    func loadUserDetail(_ id: String)
    func loadStudentDetails(_ id: String)
}

protocol UserDetailsProviderDelegate: ErrorResponseProtocol {
    func onUserDetailLoaded(_ userDetails: UserDetail)

}

class UserDetailsProvider: RestApiManager, UserDetailsProviderProtocol {


    weak  var delegate: UserDetailsProviderDelegate!

    private var endpoint: String = "/users"
    func loadUserDetail() {
        endpoint = "/users"
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let user = try? self.changeJsonToResposne(json,errorR: self.delegate) {

                self.delegate?.onUserDetailLoaded(user.data)
            }
        }, onError: {[unowned self] text in  self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    func loadUserDetail(_ id: String) {
        endpoint = "/lecturers/" + id
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

           if let user = try? self.changeJsonToResposne(json, errorR: self.delegate){
               self.delegate?.onUserDetailLoaded(user.data)
           }
        }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
    }

    func loadStudentDetails(_ id: String) {
        endpoint = "/users/" + id
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let user = try? self.changeJsonToResposne(json, errorR: self.delegate){
                self.delegate?.onUserDetailLoaded(user.data)
            }
        }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
    }
}

