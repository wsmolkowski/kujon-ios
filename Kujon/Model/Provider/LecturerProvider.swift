//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol LecturerProviderDelegate: ErrorResponseProtocol {
    func onLecturersLoaded(lecturers: Array<SimpleUser>)

    func onLecturerDetailsLoaded(lecturer: LecturerDetail)

}

class LecturerProvider {
    var delegate :LecturerProviderDelegate!
    func loadLecturers(){
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("Lecturers", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            let userDetailR = try! UserDetailsResponse.decode(json)
//            delegate?.onLecturersLoaded(userDetailR.data)
        } catch {
            delegate?.onErrorOccurs()
        }
    }


    func loadLecturerDetails(id:String){
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("LecturerDetails", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            let userDetailR = try! UserDetailsResponse.decode(json)
//            delegate?.onLecturerDetailsLoaded(userDetailR.data)
        } catch {
            delegate?.onErrorOccurs()
        }
    }
}
