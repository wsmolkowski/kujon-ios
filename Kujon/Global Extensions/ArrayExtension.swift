//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


extension Array {

    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [G: [Element]] {
        var dictionary = [G: [Element]]()

        for element in self {
            let key = groupClosure(element)
            var array: [Element]? = dictionary[key]

            if (array == nil) {
                array = [Element]()
            }

            array!.append(element)
            dictionary[key] = array!
        }

        return dictionary
    }
}
