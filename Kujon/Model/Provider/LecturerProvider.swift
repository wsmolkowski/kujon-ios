//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol LecturerProviderProtocol:JsonProviderProtocol{
    typealias T = LecturersResponse
    func loadLecturers()
}


protocol LecturerProviderDelegate: ErrorResponseProtocol {
    func onLecturersLoaded(lecturers: Array<SimpleUser>)
}

class LecturerProvider: LecturerProviderProtocol {
    static  let sharedInstance  = LecturerProvider()
    var delegate :LecturerProviderDelegate!
    func loadLecturers(){
        do {

            let jsonData = try JsonDataLoader.loadJson("Lecturers")
            let lecturers = try! self.changeJsonToResposne(jsonData)
            delegate?.onLecturersLoaded(lecturers.data)
        } catch {
            delegate?.onErrorOccurs()
        }
    }
}