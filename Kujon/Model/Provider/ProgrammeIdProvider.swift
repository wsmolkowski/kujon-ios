//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol ProgrammeIdProviderProtocol: JsonProviderProtocol {
    associatedtype T = ProgrameIdResponse

    func loadProgramme(id: String)
}

protocol ProgrammeIdProviderDelegate: ErrorResponseProtocol {
    func onProgrammeLoaded(id:String, programme: StudentProgramme)

}

class ProgrammeIdProvider: RestApiManager, ProgrammeIdProviderProtocol {
    var delegate: ProgrammeIdProviderDelegate! = nil
    var endpoint = "/programmes"

    func loadProgramme(id: String) {
        endpoint = "/programmes/" + id
        self.makeHTTPAuthenticatedGetRequest({
            json in
            if let programeResponse = try! self.changeJsonToResposne(json,errorR: self.delegate) {
                let programmeEnd = programeResponse.singleProgramme.getProgramme()
                self.delegate?.onProgrammeLoaded(id,programme: StudentProgramme(id: id,programme: programmeEnd))
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    override func getMyFakeJsonName() -> String! {
        return "Programmes"
    }


}
