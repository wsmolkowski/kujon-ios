//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol GradesProviderProtocol: JsonParsing {
    associatedtype T = GradeResponse

    func loadGrades()
}

protocol GradesProviderDelegate: ErrorHandlingDelegate {
    func onGradesLoaded(preparedTermGrades: Array<PreparedTermGrades>)

}

class GradesProvider: RestApiManager, GradesProviderProtocol {
weak var delegate: GradesProviderDelegate!


    func loadGrades() {

        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            do {
                if let grades = try strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {

                    var preparedTermGrades = Array<PreparedTermGrades>()
                    if grades.data.count > 0 {
                        for i in  0...grades.data.count - 1 {

                            let termGrade = grades.data[i]
                            let termAverageGrade = termGrade.averageGrade
                            var preparedGrades  = Array<PreparedGrades>()
                            for j in 0...termGrade.grades.count - 1 {

                                let courseGrade = termGrade.grades[j]

                                for k in 0...courseGrade.grades.count - 1{

                                    let grade = courseGrade.grades[k]
                                    preparedGrades.append(PreparedGrades(
                                            courseName: courseGrade.courseName ,
                                            courseId: courseGrade.courseId ,
                                            grades: grade ,
                                            termId:courseGrade.termId))
                                }
                            }
                            preparedTermGrades.append(PreparedTermGrades(termId: termGrade.termId, grades: preparedGrades, averageGrade: termAverageGrade))
                        }
                    }
                    strongSelf.delegate?.onGradesLoaded(preparedTermGrades:preparedTermGrades)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                strongSelf.delegate.onErrorOccurs()
            }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })

    }

    override func getMyUrl() -> String {
        return baseURL + "/gradesbyterm"
    }

}
