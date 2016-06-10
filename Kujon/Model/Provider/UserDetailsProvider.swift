//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
protocol UserDetailsProviderDelegate: ErrorResponseProtocol {
    func onUserDetailLoaded(userDetails: UserDetail)

}
class UserDetailsProvider {
    var delegate: UserDetailsProviderDelegate!


    func loadUserDetail() {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("User", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            let userDetailR = try! UserDetailsResponse.decode(json)
            delegate?.onUserDetailLoaded(userDetailR.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }
}

