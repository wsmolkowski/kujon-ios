//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

protocol OnImageLoadedFromRest {
    func imageLoaded(tag: String, image: UIImage)
}

class RestImageProvider {
    static let sharedInstance =  RestImageProvider()
    private let headerManager = HeaderManager()


     func loadImage(tag: String, urlString: String, onImageLoaded: OnImageLoadedFromRest) {
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        self.headerManager.addHeadersToRequest(&request)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            if (data != nil) {

                if let image = UIImage(data: data!,scale: 1.0) {
                    dispatch_async(dispatch_get_main_queue()) {
                        onImageLoaded.imageLoaded(tag,image: image)
                    }
                }


            }
        })
        task.resume()
    }


}
