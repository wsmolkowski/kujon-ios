//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol ProgrammeIdProviderProtocol: JsonParsing {
    associatedtype T = ProgrameIdResponse

    func loadProgramme(_ id: String)
}

protocol ProgrammeIdProviderDelegate: ResponseHandlingDelegate {
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
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let programeResponse = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
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
