//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Thesis : Decodable{

    let authors:Array<SimpleUser>
    let faculty:FacultyShort
    let id : String
    let title: String
    let type: String
    let supervisors: Array<SimpleUser>

    static func decode(_ j: Any) throws -> Thesis {
        return try Thesis(authors: j => "authors",
                faculty: j => "faculty",
                id: j => "id",
                title: j => "title",
                type: Thesis.mapThesisType(j => "type"),
                supervisors: j => "supervisors")
    }


    static func mapThesisType(_ type: String) -> String {
        switch type {
        case "doctoral":
            return StringHolder.thesisTypeDoctoral
        case "master":
            return StringHolder.thesisTypeMaster
        case "licentiate":
            return StringHolder.thesisTypeLicentiate
        case "engineer":
            return StringHolder.thesisTypeEngineer
        case "postgraduate":
            return StringHolder.thesisTypePostgraduate
        default:
            return StringHolder.none
        }
    }

}
