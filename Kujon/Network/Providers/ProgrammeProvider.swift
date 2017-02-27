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
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let programeResponse = try! strongSelf.changeJsonToResposne(json, errorR: strongSelf.delegate) {
                strongSelf.delegate?.onProgrammeLoaded(programeResponse.list)
            }

        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })
    }

    override func getMyUrl() -> String {
        return baseURL + "/programmes"
    }

    override func getMyFakeJsonName() -> String! {
        return "Programmes"
    }


}
