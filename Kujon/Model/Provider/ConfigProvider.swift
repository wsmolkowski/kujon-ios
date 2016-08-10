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
    var delegate: ConfigProviderDelegate! = nil

    func checkConfig() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
            if let configRes = try! self.changeJsonToResposne(json, onError: {
                text in
                self.delegate?.onErrorOccurs(text)
            }) {
                let config = configRes.data
                if (!config.userLogged) {
                    self.delegate?.notLogged()
                    return
                }
                if (!config.usosWorks) {
                    self.delegate?.usosDown()
                    return
                }

                if (config.usosPaired) {
                    self.delegate?.pairedWithUsos()
                } else {
                    self.delegate?.notPairedWithUsos()
                }

            }
        }, onError: {
            text in
            self.delegate?.onErrorOccurs(text) })

    }

    override func getMyUrl() -> String {
        return self.baseURL + "/config"
    }


}
