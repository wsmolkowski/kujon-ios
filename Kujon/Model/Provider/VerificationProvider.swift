//
//  VerificationProvider.swift
//  Kujon
//
//  Created by Adam on 15.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol VerificationProviderProtocol {
    //associatedtype T = FacultieResponse
    func verify(URLString: String)
}

protocol VerificationProviderDelegate: ErrorResponseProtocol {
    func onVerificationSuccess(_ data: Data)
    func onVerificationFailure(_ error: Error)
}

class VerificationProvider: RestApiManager, VerificationProviderProtocol {

    weak var delegate: VerificationProviderDelegate?
    private var headerManager = HeaderManager()

    func verify(URLString: String) {

        var request = URLRequest(url: URL(string: URLString)!)
        request.setValue(cookies(), forHTTPHeaderField: "Cookie")
        self.headerManager.addHeadersToRequest(&request)
        let session = SessionManager.provideSession()

        let task = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            if error == nil, let data = data {
                self.delegate?.onVerificationSuccess(data)
                return
            }
            if let error = error {
                self.delegate?.onVerificationFailure(error)
            }

        }

        task.resume()

        /*


         self.makeHTTPAuthenticatedGetRequest({
         [unowned self] json in



         if let facult = try! self.changeJsonToResposne(json,errorR: self.delegate){
         self.delegate?.onVerificationResponse(facult.list)
         }
         }, onError: {[unowned self] text in self.delegate?.onErrorOccurs() })
         */
    }

    private func cookies() -> String {
        var result: String = ""
        guard let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: RestApiManager.BASE_URL)!) else {
            return ""
        }
        cookies.forEach {
            result = result + ($0 as HTTPCookie).name + "=" + ($0 as HTTPCookie).value + ";"
        }
        return result
    }

}
