//
//  MessageProvider.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 25/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol MessageProviderProtocol: JsonProviderProtocol {
    associatedtype T = MessageResponse
    
    func loadMessage()
    
    
}

protocol MessageProviderDelegate: ErrorResponseProtocol {
    func onMessageLoaded(_ message: Array<Message>)

}


class MessageProvider: RestApiManager,MessageProviderProtocol  {
    
    weak var delegate: MessageProviderDelegate!  = nil
    
    
    internal func loadMessage() {
        self.makeHTTPAuthenticatedGetRequest({
            json in
            if let messageResponse = try! self.changeJsonToResposne(json,errorR: self.delegate){
                
                self.delegate?.onMessageLoaded(messageResponse.data)
            }
        }) { text in self.delegate?.onErrorOccurs()}
    }

    
    override func getMyUrl() -> String {
        return baseURL + "/messages"
    }

    override func getMyFakeJsonName() -> String! {
        return "Message"
    }


}
