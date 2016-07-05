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
    var delegate: UsosesProviderDelegate!

    func loadUsoses() {
        self.makeHTTPGetRequest({
            json in
            do {
                if let usoses = try! self.changeJsonToResposne(json,onError: {
                    self.delegate?.onErrorOccurs()
                }){

                    self.delegate?.onUsosesLoaded(usoses.data)
                }
            } catch {
                NSlogManager.showLog("JSON serialization failed:  \(error)")
                self.delegate.onErrorOccurs()
            }
        }, onError: {})

    }

    override func getMyUrl() -> String {
        return baseURL + "/usoses"
    }

}
