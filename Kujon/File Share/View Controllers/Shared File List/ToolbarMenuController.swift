//
//  ToolbarMenuController.swift
//  Kujon
//
//  Created by Adam on 03.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

enum ToolbarMenuState {
    case allFiles
    case mineFiles
}

protocol ToolbarMenuControllerDelegate: class {

    func toolbarMenuControllerDidSelectState(_ state: ToolbarMenuState)
}

class ToolbarMenuController: UIViewController {

    @IBOutlet weak var allFilesButton: UIButton!
    @IBOutlet weak var mineFilesButton: UIButton!
    @IBOutlet weak var allFilesButtonUnderline: UIView!
    @IBOutlet weak var mineFilesButtonUnderline: UIView!
    internal weak var delegate: ToolbarMenuControllerDelegate?
    private let disabledButtonColor = UIColor.white(alpha: 0.5)

    internal var state: ToolbarMenuState = .allFiles {
        didSet {
            delegate?.toolbarMenuControllerDidSelectState(state)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allFilesButtonUnderline.layer.cornerRadius = 2.0
        mineFilesButtonUnderline.layer.cornerRadius = 2.0
        configureAllFilesState()
    }

    @IBAction func allFilesButtonDidTap(_ sender: UIButton) {
        if state != .allFiles {
            configureAllFilesState()
        }
    }

    @IBAction func mineFilesButtonDidTap(_ sender: UIButton) {
        if state != .mineFiles {
            configureMineFilesState()
        }
    }

    internal func reset() {
        configureAllFilesState()
    }

    private func configureAllFilesState() {
        state = .allFiles

        allFilesButton.setTitleColor(.white, for: .normal)
        allFilesButtonUnderline.isHidden = false

        mineFilesButton.setTitleColor(disabledButtonColor, for: .normal)
        mineFilesButtonUnderline.isHidden = true
    }

    private func configureMineFilesState() {
        state = .mineFiles

        allFilesButton.setTitleColor(disabledButtonColor, for: .normal)
        allFilesButtonUnderline.isHidden = true

        mineFilesButton.setTitleColor(.white, for: .normal)
        mineFilesButtonUnderline.isHidden = false
    }
}
