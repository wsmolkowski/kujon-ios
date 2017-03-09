//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol UsosProviderProtocol: JsonParsing {
    associatedtype T = KujonResponseSchools

    func loadUsoses()
}

protocol UsosesProviderDelegate: ResponseHandlingDelegate {
    func onUsosesLoaded(_ arrayOfUsoses: Array<Usos>)

}

class UsosesProvider: RestApiManager, UsosProviderProtocol {
    weak var delegate: UsosesProviderDelegate!

    func loadUsoses() {
        self.makeHTTPGetRequest({ [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            if let mySelf = self,
                let usoses = try! mySelf.parseResposne(json, errorHandler: mySelf.delegate) {
                    mySelf.delegate?.onUsosesLoaded(usoses.data)
            }
        }, onError: {[weak self] text in
            self?.delegate?.onErrorOccurs(text, retry: false)
        })
    }

    override func getMyUrl() -> String {
        return baseURL + "/usosesall"
    }

}
