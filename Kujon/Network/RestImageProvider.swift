//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

protocol OnImageLoadedFromRest {
    func imageLoaded(_ tag: String, image: UIImage)
}

class RestImageProvider {

    static let sharedInstance =  RestImageProvider()
    private let headerManager = HeaderManager()

    func loadImage(_ tag: String, urlString: String, onImageLoaded: OnImageLoadedFromRest) {
        var request = URLRequest(url: URL(string: urlString)!)
        self.headerManager.addHeadersToRequest(&request)
        let session = SessionManager.provideSession()
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error -> Void in
            if let data = data,
                let image = UIImage(data: data, scale: 1.0){
                DispatchQueue.main.async {
                    onImageLoaded.imageLoaded(tag, image:image)
                }
            }
        })
        task.resume()
    }
}
