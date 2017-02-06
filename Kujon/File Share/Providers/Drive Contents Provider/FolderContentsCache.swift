//
//  FolderContentsCache.swift
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol FolderContentsCachable {

    func save(item: FolderContents)
    func loadItem(folderId: String) -> FolderContents?
    func clearCache()

}

class FolderContentsCache: FolderContentsCachable {

    static let shared = FolderContentsCache()
    private var cache: Set<FolderContents> = Set()

    func save(item: FolderContents) {
        cache.insert(item)
    }

    func loadItem(folderId: String) -> FolderContents? {
        let contents = cache.filter({ $0.folderId == folderId }).first
        return contents
    }

    func clearCache() {
        cache = []
    }

    func count() -> Int {
        return cache.count
    }
}
