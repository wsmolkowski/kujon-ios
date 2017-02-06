//
//  DriveBrowserConfigurable
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

enum DriveBrowserMode {
    case selectFile
    case chooseFolder
}

typealias DriveBrowserActionHandler = ((_ browser: DriveBrowser) -> Void)
typealias DriveBrowserButtonItem = (title: String, action: DriveBrowserActionHandler)

protocol DriveBrowserConfigurable: class {

    var mode: DriveBrowserMode { get }

    var leftNavigationBarButton: DriveBrowserButtonItem? { get set }

    var rightNavigationBarButton: DriveBrowserButtonItem? { get set }

    var isFileSelectionEnabled: Bool { get }
    
}
