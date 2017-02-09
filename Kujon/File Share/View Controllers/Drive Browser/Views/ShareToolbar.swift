//
//  ShareToolbar.swift
//  Kujon
//
//  Created by Adam on 19.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

protocol ShareToolbarDelegate: class {

    func shareToolbarTitle() -> String
}

class ShareToolbar: UIToolbar {

    internal weak var toolbarDelegate: ShareToolbarDelegate?
    private var title: String = "Udostępnij wybrany plik"
    private var titleLabel: UILabel?
    private let toolbarHeight: CGFloat = 105.0
    private let textLabelHeight: CGFloat = 40.0

    override var isHidden: Bool {
        didSet {
            if !isHidden {
                updateTitle()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomView()
    }

    internal func updateTitle() {
        guard let titleLabel = titleLabel else {
            return
        }
        if  let toolbarDelegate = toolbarDelegate {
            title = toolbarDelegate.shareToolbarTitle()
        }
        let titleAttributed = title.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 16.0)!, color: .white)
        titleLabel.attributedText = titleAttributed
    }

    private func setupCustomView() {
        let view = UIView()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        view.backgroundColor = UIColor.kujonBlueColor()
        view.tintColor = UIColor.white

        let titleLabelFrame: CGRect = CGRect(x: 0, y: 15, width: view.bounds.size.width, height: textLabelHeight)
        let titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel

        updateTitle()
        addSubview(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = bounds
        frame.size.height = toolbarHeight
        frame.origin.y = UIScreen.main.bounds.size.height - frame.size.height
        self.frame = frame
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = toolbarHeight
        return size
    }




}

