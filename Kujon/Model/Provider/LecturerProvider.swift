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
    var delegate :LecturerProviderDelegate!
    func loadLecturers(){
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("Lecturers", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let lecturers = try! self.changeJsonToResposne(jsonData)
            delegate?.onLecturersLoaded(lecturers.data)
        } catch {
            delegate?.onErrorOccurs()
        }
    }
}