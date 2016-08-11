//
// Created by Wojciech Maciejewski on 06/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UsosHolderController:UIViewController {


    var centerNavigationController: UINavigationController!



    override func viewDidLoad() {
        super.viewDidLoad()

        centerNavigationController = UINavigationController(rootViewController: UsosesTableViewController())
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)

        centerNavigationController.didMoveToParentViewController(self)

    }
}
