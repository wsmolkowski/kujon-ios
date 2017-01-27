//
// Created by Wojciech Maciejewski on 14/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol ProgrammeProviderProtocol: JsonProviderProtocol {
    associatedtype T = StudentProgrammeResponse

    func loadProgramme()


}

protocol ProgrammeProviderDelegate: ErrorResponseProtocol {
    func onProgrammeLoaded(_ terms: Array<StudentProgramme>)

}

class ProgrammeProvider: RestApiManager, ProgrammeProviderProtocol {
    weak var delegate: ProgrammeProviderDelegate! = nil

    func loadProgramme() {
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in
            if let programeResponse = try! self.changeJsonToResposne(json,errorR: self.delegate) {

                self.delegate?.onProgrammeLoaded(programeResponse.list)
            }
        }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return baseURL + "/programmes"
    }

    override func getMyFakeJsonName() -> String! {
        return "Programmes"
    }


}
