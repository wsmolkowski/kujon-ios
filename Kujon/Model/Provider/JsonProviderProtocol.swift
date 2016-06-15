//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

protocol JsonProviderProtocol {
    associatedtype T:Decodable

}
extension JsonProviderProtocol{
     func changeJsonToResposne(jsonData:NSData) throws ->T  {
        let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        return try! T.decode(json)
    }
}