//
// Created by Wojciech Maciejewski on 15/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private var userDefaults:UserDefaults

    init(withNSUserDefaults defaults:UserDefaults){
        self.userDefaults = defaults
    }



    func readStringFromUserDefaults(_ key:String)->String!{
        return self.userDefaults.string(forKey: key)
    }

    func writeStringToUserDefaults(_ value:String!,key:String){
        if(value != nil){
            self.userDefaults.set(value,forKey: key)
        }else {
            self.userDefaults.removeObject(forKey: key)
        }

    }

    func readBooleanFromUserDefaults(_ key:String) ->Bool{
        return self.userDefaults.bool(forKey: key)
    }

    func writeBoolToUserDefaults(_ value:Bool,key:String){
        self.userDefaults.set(value,forKey: key)
    }
}
