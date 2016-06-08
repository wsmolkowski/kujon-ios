//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation


protocol UsosesProviderDelegate{
    func onUsosesLoaded(arrayOfUsoses:Array<Usos>)
    func onErrorOccurs()
}

class UsosesProvider {
    var delegate:UsosesProviderDelegate!



    func loadUsoses(){
        let txtFilePath = NSBundle.mainBundle().pathForResource("Usoses", ofType: "json")

        do {

            let txtFilePath = NSBundle.mainBundle().pathForResource("Usoses", ofType: "json")

            var jsonData = try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            var usoses = try! KujonResponseSchools.decode(json)
            delegate?.onUsosesLoaded(usoses.data)
        } catch {
            delegate?.onErrorOccurs()
        }

    }

}
