//
//  SortKeyProviding.swift
//  Kujon
//
//  Created by Adam on 25.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

protocol SortKeyProviding {

    var sortKey: String { get }
    
}


extension Array where Element: SortKeyProviding {

    func filterWithKey(_ filterKey: String) -> [SortKeyProviding] {

        var filteredArray: [SortKeyProviding] = self

        if !filterKey.isEmpty  {
            let whiteSpaceCharacterSet = NSCharacterSet.whitespacesAndNewlines
            let clearKey = filterKey.trimmingCharacters(in: whiteSpaceCharacterSet)
            let keys = clearKey.components(separatedBy: " ")
            filteredArray = self.filter { item in
                for key in keys {
                    if !item.sortKey.lowercased().contains(key.lowercased()) {
                        return false
                    }
                }
                return true
            }
        }

        return filteredArray
    }

}
