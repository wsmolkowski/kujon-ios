//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol UserDetailsProviderProtocol: JsonProviderProtocol {
    associatedtype T = UserDetailsResponse

    func loadUserDetail()

    func loadUserDetail(id: String)
}

protocol UserDetailsProviderDelegate: ErrorResponseProtocol {
    func onUserDetailLoaded(userDetails: UserDetail)

}

class UserDetailsProvider: RestApiManager, UserDetailsProviderProtocol {


    var delegate: UserDetailsProviderDelegate!

    private var endpoint: String = "/users"
    func loadUserDetail() {
        endpoint = "/users"
        self.makeHTTPAuthenticatedGetRequest({
            json in

            if let user = try! self.changeJsonToResposne(json, onError: {
                text in
                self.delegate?.onErrorOccurs(text)
            }) {

                self.delegate?.onUserDetailLoaded(user.data)
            }
        }, onError: {text in  self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    func loadUserDetail(id: String) {
        endpoint = "/lecturers/" + id
        self.makeHTTPAuthenticatedGetRequest({
            json in
           if let user = try! self.changeJsonToResposne(json, onError: {
                text in
                self.delegate?.onErrorOccurs()
            }){
               self.delegate?.onUserDetailLoaded(user.data)
           }
        }, onError: {text in self.delegate?.onErrorOccurs() })
    }
}

