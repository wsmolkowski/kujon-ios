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
    func onGradesLoaded(termGrades: Array<PreparedTermGrades>)

}

class GradesProvider: RestApiManager, GradesProviderProtocol {
    var delegate: GradesProviderDelegate!


    func loadGrades() {

        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                if let grades = try self.changeJsonToResposne(json,onError: {
                    text in
                    self.delegate?.onErrorOccurs(text)
                }){
                    var preparedTermGrades = Array<PreparedTermGrades>()
                    for termGrade in  grades.data{
                        var preparedGrade  = Array<PreparedGrades>()
                        for courseGrade in termGrade.grades{
                            for grade in courseGrade.grades{
                                preparedGrade.append(PreparedGrades(
                                        courseName: courseGrade.courseName ,
                                        courseId: courseGrade.courseId ,
                                        grades: grade ,
                                        termId:courseGrade.termId))
                            }
                        }
                        preparedTermGrades.append(PreparedTermGrades(termId: termGrade.termId,grades: preparedGrade))
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
