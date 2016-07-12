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


    func loadGrades() {

        self.makeHTTPAuthenticatedGetRequest({
            json in
            do {
                if let grades = try self.changeJsonToResposne(json,onError: {
                    text in
                    self.delegate?.onErrorOccurs()
                }){

                    self.delegate?.onGradesLoaded(grades.data)
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
