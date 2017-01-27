//
//  KujonAppearance
//  Kujon
//
//  Created by Adam on 25.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class KujonAppearance {

    static func setSearchBarAppearance() {
        let barButtonAppearanceInSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self])
        let attr: [String: Any] = [ NSFontAttributeName : UIFont.kjnFontLatoRegular(size: 16)!,
                     NSForegroundColorAttributeName : UIColor.kujonBlueColor() ]
        barButtonAppearanceInSearchBar.setTitleTextAttributes(attr, for: .normal)
        barButtonAppearanceInSearchBar.title = StringHolder.cancel
    }
}
