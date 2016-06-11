//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol UserDetailsProviderProtocol: JsonProviderProtocol {
    typealias T = UserDetailsResponse
    func loadUserDetail()
    func loadUserDetail(id:String)
}

protocol UserDetailsProviderDelegate: ErrorResponseProtocol {
    func onUserDetailLoaded(userDetails: UserDetail)

}

class UserDetailsProvider: UserDetailsProviderProtocol {
    var delegate: UserDetailsProviderDelegate!


    func loadUserDetail() {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("User", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let userDetailR = try! self.changeJsonToResposne(jsonData)
            delegate?.onUserDetailLoaded(userDetailR.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }

    func loadUserDetail(id: String) {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("LecturerDetails", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let userDetailR = try! self.changeJsonToResposne(jsonData)
            delegate?.onUserDetailLoaded(userDetailR.data)
        } catch {
            delegate?.onErrorOccurs()
        }
    }

}

