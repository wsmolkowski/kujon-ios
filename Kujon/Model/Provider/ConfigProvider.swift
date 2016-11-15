//
// Created by Wojciech Maciejewski on 10/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ConfigProviderProtocol: JsonProviderProtocol {
    associatedtype T = ConfigResponse

    func checkConfig()

}

protocol ConfigProviderDelegate: ErrorResponseProtocol {
    func notLogged()

    func pairedWithUsos()

    func notPairedWithUsos()

    func usosDown()
}

class ConfigProvider: RestApiManager, ConfigProviderProtocol {
    weak var delegate: ConfigProviderDelegate! = nil

    func checkConfig() {
        self.makeHTTPAuthenticatedGetRequest({
            [unowned self] json in


            if let configRes = try! self.changeJsonToResposne(json,errorR: self.delegate) {
                let config = configRes.data
                if (!config.userLogged) {
                    self.delegate?.notLogged()
                    return
                }

                if (config.usosPaired) {
                    if (!config.usosWorks) {
                        self.delegate?.usosDown()
                        return
                    }
                    //TODO: REVERT
                    self.delegate?.notPairedWithUsos()
                    //self.delegate?.pairedWithUsos()
                    return
                } else {
                    self.delegate?.notPairedWithUsos()
                    return
                }

            }
        }, onError: {
            [unowned self] text in
            self.delegate?.onErrorOccurs(text)
        })

    }

    override func getMyUrl() -> String {
        return self.baseURL + "/config"
    }


}
