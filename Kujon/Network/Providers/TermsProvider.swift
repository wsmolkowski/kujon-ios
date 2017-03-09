//
// Created by Wojciech Maciejewski on 12/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol TermsProviderProtocol: JsonParsing {
    associatedtype T = TermsResponse

    func loadTerms()
}

protocol TermsProviderDelegate: ErrorHandlingDelegate {
    func onTermsLoaded(_ terms: Array<Term>)

}

class TermsProvider: RestApiManager, TermsProviderProtocol {
    weak   var delegate: TermsProviderDelegate! = nil
    func loadTerms() {
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let termsResponse = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                strongSelf.delegate?.onTermsLoaded(termsResponse.terms)
            }

        }, onError: { [weak self] text in
            self?.delegate?.onErrorOccurs()
        })
    }

    override func getMyUrl() -> String {
        return baseURL + "/terms"
    }

    override func getMyFakeJsonName() -> String! {
        return "Terms"
    }


}
