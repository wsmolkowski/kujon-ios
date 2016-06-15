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

    static let sharedInstance = UserDetailsProvider()

    var delegate: UserDetailsProviderDelegate!


    func loadUserDetail() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
            let user = try! self.changeJsonToResposne(json)
            self.delegate?.onUserDetailLoaded(user.data)
        }, onError: {self.delegate?.onErrorOccurs()})
    }

    override func getMyUrl() -> String {
        return baseURL + "/users"
    }

    func loadUserDetail(id: String) {
        do {
            let jsonData = try JsonDataLoader.loadJson("LecturerDetails")
            let userDetailR = try! self.changeJsonToResposne(jsonData)
            delegate?.onUserDetailLoaded(userDetailR.data)
        } catch {
            delegate?.onErrorOccurs()
        }
    }
}

