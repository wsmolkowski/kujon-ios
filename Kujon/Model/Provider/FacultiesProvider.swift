//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultiesProviderProtocol: JsonProviderProtocol {
    typealias T = FacultieResposne

    func loadFaculties()
}

protocol FacultiesProviderDelegate:ErrorResponseProtocol {
    func onFacultiesLoaded(list: Array<Facultie>)
}

class FacultiesProvider: FacultiesProviderProtocol {
     var delegate:FacultiesProviderDelegate! = nil

    func loadFaculties() {
        do {
            let jsonData = try JsonDataLoader.loadJson("FacultiesDetail")
            let faculties = try self.changeJsonToResposne(jsonData)
            delegate?.onFacultiesLoaded(faculties.list)
        } catch {
            delegate?.onErrorOccurs()
        }

    }

}
