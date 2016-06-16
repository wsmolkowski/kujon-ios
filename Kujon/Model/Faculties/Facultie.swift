//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

//{
//    "logo_urls": {
//    "100x100": "https://usosapps.demo.usos.edu.pl/res/fl/100x100/d1ca3aaf52b41acd68ebb3bf69079bd1-015c75d8f8baf334151c0886b869a580e593dc02.jpg"
//},
//    "stats": {
//    "course_count": 440,
//    "programme_count": 39,
//    "staff_count": 445
//},
//    "name": "Wydział Matematyki, Informatyki i Mechaniki",
//    "postal_address": "Banacha 2, 02-097 Warszawa",
//    "fac_id": "10000000",
//    "homepage_url": "http://www.mimuw.edu.pl/",
//    "path": [
//{
//"id": "00000000",
//"name": {
//"en": "University of Warsaw",
//"pl": "Uniwersytet Warszawski"
//}
//}
//],
//    "phone_numbers": [
//"1231409"
//]
//}

struct Facultie {

    let logUrls: LogoUrls
    let schoolStats: SchoolStats
    let name: String
    let postalAdress: String
    let facultyId: String
    let homePageUrl: String!
    let schoolPath: Array<SchoolPath>
    let phoneNumber: Array<String>
}


extension Facultie: Decodable {
    static func decode(j: AnyObject) throws -> Facultie {
        return try Facultie(
        logUrls: j => "logo_urls",
                schoolStats: j => "stats",
                name: j => "name",
                postalAdress: j => "postal_address",
                facultyId: j => "fac_id",
                homePageUrl: j => "homepage_url",
                schoolPath: j => "path",
                phoneNumber: j => "phone_numbers"
        )
    }

}