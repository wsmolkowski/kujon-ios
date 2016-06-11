//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol GradesProviderProtocol:JsonProviderProtocol {
    typealias T=GradeResponse
    func loadGrades()
}

protocol GradesProviderDelegate: ErrorResponseProtocol {
    func onGradesLoaded(termGrades: Array<TermGrades>)

}

class GradesProvider: GradesProviderProtocol {
    var delegate: GradesProviderDelegate!

    func loadGrades() {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("Grades", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let grades = try self.changeJsonToGradeResposne(jsonData)
            delegate?.onGradesLoaded(grades.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }
}
