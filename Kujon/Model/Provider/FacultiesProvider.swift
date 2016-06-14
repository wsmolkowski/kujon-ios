//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol FacultiesProviderProtocol: JsonProviderProtocol {
    typealias T = FacultieResposne

    func loadFaculties()
}

protocol FacultiesProviderDelegate {
    func onFacultiesLoaded(list: Array<Facultie>)
}

class FacultiesProvider: FacultiesProviderProtocol {

    func loadFaculties() {

    }

}
