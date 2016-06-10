//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol UsosesProviderDelegate: ErrorResponseProtocol {
    func onUsosesLoaded(arrayOfUsoses: Array<Usos>)

}

class UsosesProvider {
    var delegate: UsosesProviderDelegate!


    func loadUsoses() {

        do {

            let txtFilePath = NSBundle.mainBundle().pathForResource("Usoses", ofType: "json")

            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            let usoses = try! KujonResponseSchools.decode(json)
            delegate?.onUsosesLoaded(usoses.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }

}
