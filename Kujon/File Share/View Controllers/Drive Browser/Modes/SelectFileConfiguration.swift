//
//  SelectFileConfiguration
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

typealias SelectedItem = (file: GTLRDrive_File, index: Int)

protocol SelectFileConfigurable: DriveBrowserConfigurable {

    var courseId: String? { get set }
    var termId: String? { get set }
    var selectedItem: SelectedItem? { get set }

}

class SelectFileConfiguration: SelectFileConfigurable {


    var mode: DriveBrowserMode {
        return .selectFile
    }

    var leftNavigationBarButton: DriveBrowserButtonItem?

    var rightNavigationBarButton: DriveBrowserButtonItem? = (title: StringHolder.cancel, action: { browser in
        browser.dismissBrowser()
    })

    var isFileSelectionEnabled = true

    var selectedItem: SelectedItem?

    var courseId: String?

    var termId: String?

    init(courseId: String, termId: String, selectedFile: SelectedItem? = nil) {
        self.courseId = courseId
        self.termId = termId
        self.selectedItem = selectedFile
    }
    
}
