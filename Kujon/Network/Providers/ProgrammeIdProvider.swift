//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol ProgrammeIdProviderProtocol: JsonProviderProtocol {
    associatedtype T = ProgrameIdResponse

    func loadProgramme(_ id: String)
}

protocol ProgrammeIdProviderDelegate: ErrorResponseProtocol {
    func onProgrammeLoaded(_ id:String, programme: StudentProgramme)

}

class ProgrammeIdProvider: RestApiManager, ProgrammeIdProviderProtocol {
    weak var delegate: ProgrammeIdProviderDelegate! = nil
    var endpoint = "/programmes"

    func loadProgramme(_ id: String) {
        endpoint = "/programmes/" + id
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
                let programmeEnd = programeResponse.singleProgramme.getProgramme()
                strongSelf.delegate?.onProgrammeLoaded(id,programme: StudentProgramme(id: id,programme: programmeEnd, status: nil))
            }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs()
        })
    }

    override func getMyUrl() -> String {
        return baseURL + endpoint
    }

    override func getMyFakeJsonName() -> String! {
        return "Programmes"
    }


}
