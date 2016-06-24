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
    func onGradesLoaded(termGrades: Array<TermGrades>)

}

class GradesProvider: RestApiManager, GradesProviderProtocol {
    var delegate: GradesProviderDelegate!
    static let sharedInstance = GradesProvider()

    func loadGrades() {

        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                let grades = try self.changeJsonToResposne(jsonData)
                delegate?.onGradesLoaded(grades.data)
            } catch {
                delegate?.onErrorOccurs()
            }
        }, onError: { self.delegate?.onErrorOccurs() })

    }

    override func getMyUrl() -> String {
        return baseURL + "/gradesbyterm"
    }

}
