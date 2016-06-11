//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol UsosProviderProtocol: JsonProviderProtocol {
    typealias T = KujonResponseSchools
    func loadUsoses()
}

protocol UsosesProviderDelegate: ErrorResponseProtocol {
    func onUsosesLoaded(arrayOfUsoses: Array<Usos>)

}

class UsosesProvider : UsosProviderProtocol {
    var delegate: UsosesProviderDelegate!


    func loadUsoses() {
        do {
            let txtFilePath = NSBundle.mainBundle().pathForResource("Usoses", ofType: "json")
            let jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let usoses = try! self.changeJsonToResposne(jsonData)
            delegate?.onUsosesLoaded(usoses.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }

}
