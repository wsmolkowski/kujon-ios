//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class Checker {


    func isEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                options: [.caseInsensitive])

        return regex.firstMatch(in: email, options:[],
                range: NSMakeRange(0, email.characters.count)) != nil
    }


    func arePasswordGoodRegex(_ password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9]+$",
                options: [.caseInsensitive])

        return regex.firstMatch(in: password, options:[],
                range: NSMakeRange(0, password.characters.count)) != nil
    }


}
