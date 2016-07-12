//
// Created by Wojciech Maciejewski on 12/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol TermsProviderProtocol: JsonProviderProtocol {
    associatedtype T = TermsResponse

    func loadTerms()
}

protocol TermsProviderDelegate: ErrorResponseProtocol {
    func onTermsLoaded(terms: Array<Term>)

}

class TermsProvider: RestApiManager, TermsProviderProtocol {
    var delegate: TermsProviderDelegate! = nil
    func loadTerms() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
            if let termsResponse = try! self.changeJsonToResposne(json, onError: {
                text in
                self.delegate?.onErrorOccurs(text)
            }) {

                self.delegate?.onTermsLoaded(termsResponse.terms)
            }
        }, onError: { text in self.delegate?.onErrorOccurs() })
    }

    override func getMyUrl() -> String {
        return baseURL + "/terms"
    }

    override func getMyFakeJsonName() -> String! {
        return "Terms"
    }


}
