//
// Created by Wojciech Maciejewski on 15/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private var userDefaults:NSUserDefaults

    init(withNSUserDefaults defaults:NSUserDefaults){
        self.userDefaults = defaults
    }



    func readStringFromUserDefaults(key:String)->String!{
        return self.userDefaults.stringForKey(key)
    }

    func writeStringToUserDefaults(value:String!,key:String){
        if(value != nil){
            self.userDefaults.setObject(value,forKey: key)
        }else {
            self.userDefaults.removeObjectForKey(key)
        }

    }

    func readBooleanFromUserDefaults(key:String) ->Bool{
        return self.userDefaults.boolForKey(key)
    }

    func writeBoolToUserDefaults(value:Bool,key:String){
        self.userDefaults.setBool(value,forKey: key)
    }
}
