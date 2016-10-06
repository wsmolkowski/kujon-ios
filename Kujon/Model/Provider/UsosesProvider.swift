//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol UsosProviderProtocol: JsonProviderProtocol {
    associatedtype T = KujonResponseSchools

    func loadUsoses()
}

protocol UsosesProviderDelegate: ErrorResponseProtocol {
    func onUsosesLoaded(arrayOfUsoses: Array<Usos>)

}

class UsosesProvider: RestApiManager, UsosProviderProtocol {
    weak var delegate: UsosesProviderDelegate!

    func loadUsoses() {
        self.makeHTTPGetRequest({
            json in
                if let usoses = try! self.changeJsonToResposne(json,errorR: self.delegate) {

                    self.delegate?.onUsosesLoaded(usoses.data)
                }
        }, onError: {text in self.delegate?.onErrorOccurs(text)})

    }

    override func getMyUrl() -> String {
        return baseURL + "/usoses"
    }

}
