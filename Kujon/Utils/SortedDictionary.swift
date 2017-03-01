//
//  SortedDictionary
//  Kujon
//
//  Created by Adam on 20.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

struct SortedDictionary<T: SortKeyProviding> {

    typealias SortedDictionaryType = [String : [T] ]

    fileprivate var sortedDictionary: SortedDictionaryType = [:]
    fileprivate (set) var sections: [String] = []
    fileprivate (set) var descriptions: [String] = []

    init() { }

    init(with items: [T], filterKey: String? = nil) {
        var items = items
        if let filterKey = filterKey {
            items = filter(items: items, with: filterKey)
        }

        var sortedDictionary: SortedDictionaryType = [:]
        var sectionKeys: Set<String> = Set()

        for item in items {
            let firstCharacter = item.sortKey.characters.first ?? Character("")
            let sectionKey = String(firstCharacter).uppercased()
            sectionKeys.insert(sectionKey)

            if var itemsInSection = sortedDictionary[sectionKey] {
                itemsInSection.append(item)
                sortedDictionary[sectionKey] = itemsInSection
            } else {
                sortedDictionary[sectionKey] = [item]
            }
        }
        self.sortedDictionary = sortedDictionary
        self.sections = [String](sectionKeys).sorted(by: <)
        self.descriptions = sections
    }

    init(coursesWrappers: [CoursesWrapper]) {
        var dictionary: SortedDictionaryType = [:]

        for wrapper in coursesWrappers {
            if let sectionKey = wrapper.title {
                sections.append(sectionKey)
                descriptions.append(String())
                var courses: [T] = []
                wrapper.courses.forEach { courses.append($0 as! T) }
                dictionary[sectionKey] = courses
            }
        }
        sortedDictionary = dictionary
    }

    init(preparedTermGrades: [PreparedTermGrades]) {
        var dictionary: SortedDictionaryType = [:]
        for termGrade in preparedTermGrades {
            let sectionKey = termGrade.termId
            sections.append(sectionKey)
            descriptions.append(termGrade.averageGradeDescriptive)
            var grades: [T] = []
            termGrade.grades.forEach { grades.append($0 as! T) }
            dictionary[sectionKey] = grades
        }
        sortedDictionary = dictionary
    }

    internal func copyFilteredWithKey(_ filterKey: String) -> SortedDictionary<T> {
        var copy = SortedDictionary<T>()

        for (index, sectionKey) in sections.enumerated() {
            let sectionItems = itemsInSection(name: sectionKey)
            let copySectionItems: [T] = filter(items: sectionItems, with: filterKey)
            if !copySectionItems.isEmpty {
                copy.sortedDictionary[sectionKey] = copySectionItems
                copy.sections.append(sectionKey)
                copy.descriptions.append(descriptions[index])
            }
        }
        return copy
    }

    internal func itemsInSection(name section: String) -> [T] {
        if let items = sortedDictionary[section] {
            return items.sorted {
                $0.sortKey < $1.sortKey
            }
        }
        return []
    }

    internal mutating func updateItemsInSection(name section: String, items: [T]) {
        sortedDictionary[section] = items
    }

    internal func itemsInSection(index: Int) -> [T] {
        let sectionName = sections[index]
        return itemsInSection(name: sectionName)
    }

    internal func itemsCountInSection(index: Int) -> Int {
        let sectionName = sections[index]
        return itemsCountInSection(name: sectionName)
    }

    internal func itemsCountInSection(name sectionName: String) -> Int {
        if let items = sortedDictionary[sectionName] {
            return items.count
        }
        return 0
    }

    internal func itemForIndexPath(_ indexPath: IndexPath) -> T {
        return itemsInSection(index: indexPath.section)[indexPath.row]
    }

    internal func toArray() -> [T] {
        var toArray: [T] = []
        sections.forEach {
            let items = itemsInSection(name: $0)
            toArray.append(contentsOf: items)
        }
        return toArray
    }

    private func filter(items:[T], with filterKey: String ) -> [T] {
        var items = items
        if !filterKey.isEmpty  {
            let whiteSpaceCharacterSet = NSCharacterSet.whitespacesAndNewlines
            let clearKey = filterKey.trimmingCharacters(in: whiteSpaceCharacterSet)
            let keys = clearKey.components(separatedBy: " ")
            items = items.filter { item in
                for key in keys {
                    if !item.sortKey.lowercased().contains(key.lowercased()) {
                        return false
                    }
                }
                return true
            }
        }
        return items
    }

}

