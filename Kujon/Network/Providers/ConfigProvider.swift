//
// Created by Wojciech Maciejewski on 10/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ConfigProviderProtocol: JsonParsing {
    associatedtype T = ConfigResponse

    func checkConfig()

}

protocol ConfigProviderDelegate: ResponseHandlingDelegate {
    func notLogged()

    func pairedWithUsos()

    func notPairedWithUsos()

    func usosDown()
}

class ConfigProvider: RestApiManager, ConfigProviderProtocol {
    weak var delegate: ConfigProviderDelegate! = nil

    func checkConfig() {
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            guard let strongSelf = self else {
                return
            }

            if let configRes = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                let config = configRes.data
                if (!config.userLogged) {
                    strongSelf.delegate?.notLogged()
                    return
                }

                if (config.usosPaired) {
                    if (!config.usosWorks) {
                        strongSelf.delegate?.usosDown()
                        return
                    }
                    strongSelf.delegate?.pairedWithUsos()
                    return
                } else {
                    strongSelf.delegate?.notPairedWithUsos()
                    return
                }

            }
        }, onError: {
            [weak self] text in
            self?.delegate?.onErrorOccurs(text, retry: false)
        })

    }

    override func getMyUrl() -> String {
        return self.baseURL + "/config"
    }


}
