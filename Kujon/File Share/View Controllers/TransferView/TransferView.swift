//
//  TransferView.swift
//  Kujon
//
//  Created by Adam on 11.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class TransferView: UIView {

    enum Action: String {
        case preparing = "Przygotowywanie"
        case addingFile = "Dodawanie pliku"
        case fileAdded = "Plik został dodany"
        case cancelling = "Trwa anulowanie operacji"
    }

    private var action: Action = .preparing {
        didSet {
            descriptionLabel.text = action.rawValue
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!

    internal weak var transfer: Transferable?

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1.0
        progressView.layer.cornerRadius = 8
        progressView.layer.masksToBounds = true
        update(action: .preparing)
    }

    internal func update(progress: Float) {
        if action == .preparing {
            action = .addingFile
        }
        guard progress >= 0.0 && progress <= 1.0 else {
            return
        }
        progressView.setProgress(progress, animated: true)
    }

    internal func update(action: Action) {
        self.action = action
    }

    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        transfer?.cancel()
        update(action: .cancelling)
    }

}
