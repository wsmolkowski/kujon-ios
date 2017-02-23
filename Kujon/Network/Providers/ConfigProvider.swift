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

            guard let json = json else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
                return
            }

            if let configRes = try? self.changeJsonToResposne(json, errorR: self.delegate) {
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
                    self.delegate?.pairedWithUsos()
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
