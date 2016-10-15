//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol GradesProviderProtocol: JsonProviderProtocol {
    associatedtype T = GradeResponse

    func loadGrades()
}

protocol GradesProviderDelegate: ErrorResponseProtocol {
    func onGradesLoaded(_ termGrades: Array<PreparedTermGrades>)

}

class GradesProvider: RestApiManager, GradesProviderProtocol {
weak var delegate: GradesProviderDelegate!


    func loadGrades() {

        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                if let grades = try self.changeJsonToResposne(json,errorR: self.delegate){
                    var preparedTermGrades = Array<PreparedTermGrades>()
                    if grades.data.count > 0 {
                        for i in  0...grades.data.count - 1 {

                            var termGrade = grades.data[i]
                            var preparedGrade  = Array<PreparedGrades>()
                            for j in 0...termGrade.grades.count - 1 {

                                var courseGrade = termGrade.grades[j]

                                for k in 0...courseGrade.grades.count - 1{

                                    var grade = courseGrade.grades[k]
                                    preparedGrade.append(PreparedGrades(
                                            courseName: courseGrade.courseName ,
                                            courseId: courseGrade.courseId ,
                                            grades: grade ,
                                            termId:courseGrade.termId))
                                }
                            }
                            preparedTermGrades.append(PreparedTermGrades(termId: termGrade.termId,grades: preparedGrade))
                        }
                    }
                    self.delegate?.onGradesLoaded(preparedTermGrades)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate.onErrorOccurs()
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })

    }

    override func getMyUrl() -> String {
        return baseURL + "/gradesbyterm"
    }

}
