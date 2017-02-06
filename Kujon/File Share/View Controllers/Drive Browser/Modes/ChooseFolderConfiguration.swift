//
//  ChooseFolderConfiguration
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol ChooseFolderConfigurable: DriveBrowserConfigurable {

    var inputFile: APIFile? { get set }
}

class ChooseFolderConfiguration: ChooseFolderConfigurable {

    var mode: DriveBrowserMode {
        return .chooseFolder
    }

    var leftNavigationBarButton: DriveBrowserButtonItem? = (title: StringHolder.cancel, action: { browser in
        browser.dismissBrowser()
    })

    var rightNavigationBarButton: DriveBrowserButtonItem? = (title: StringHolder.save, action: { browser in
        guard
            let folder = browser.contents?.currentFolder,
            let configuration = browser.configuration as? ChooseFolderConfiguration,
            let file = configuration.inputFile else {
                return
        }
        browser.saveFile(file, toDriveFolder: folder)
    })


    var isFileSelectionEnabled = false

    var inputFile: APIFile?

    var courseId: String?

    var termId: String?

    init(inputFile: APIFile) {
        self.inputFile = inputFile
    }
    
}
