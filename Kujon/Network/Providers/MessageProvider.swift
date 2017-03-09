//
//  MessageProvider.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 25/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol MessageProviderProtocol: JsonParsing {
    associatedtype T = MessageResponse
    
    func loadMessage()
    
    
}

protocol MessageProviderDelegate: ResponseHandlingDelegate {
    func onMessageLoaded(_ message: Array<Message>)

}


class MessageProvider: RestApiManager,MessageProviderProtocol  {
    
    weak var delegate: MessageProviderDelegate!  = nil
    
    
    internal func loadMessage() {
        self.makeHTTPAuthenticatedGetRequest({
            [weak self] json in

            guard let json = json else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures, retry: false)
                return
            }

            if let strongSelf = self, let messageResponse = try! strongSelf.parseResposne(json, errorHandler: strongSelf.delegate) {
                strongSelf.delegate?.onMessageLoaded(messageResponse.data)
            }
        }) {[weak self] text in
            self?.delegate?.onErrorOccurs()
        }
    }

    
    override func getMyUrl() -> String {
        return baseURL + "/messages"
    }

    override func getMyFakeJsonName() -> String! {
        return "Message"
    }


}
