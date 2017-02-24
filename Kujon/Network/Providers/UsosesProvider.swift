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
    func onUsosesLoaded(_ arrayOfUsoses: Array<Usos>)

}

class UsosesProvider: RestApiManager, UsosProviderProtocol {
    weak var delegate: UsosesProviderDelegate!

    func loadUsoses() {
        self.makeHTTPGetRequest({ [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let mySelf  = self,
                let usoses = try! mySelf.changeJsonToResposne(json,errorR: mySelf.delegate) {
                    mySelf.delegate?.onUsosesLoaded(usoses.data)
            }
        }, onError: {[weak self] text in
            if let mySelf = self{
                mySelf.delegate?.onErrorOccurs(text)
            }
        })
    }

    override func getMyUrl() -> String {
        return baseURL + "/usosesall"
    }

}
