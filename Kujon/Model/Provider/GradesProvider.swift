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
            let jsonData = try JsonDataLoader.loadJson("Grades")
            let grades = try self.changeJsonToResposne(jsonData)
            delegate?.onGradesLoaded(grades.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }
}
