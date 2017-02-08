//
//  EmptyStateViewProvider.swift
//  Kujon
//
//  Created by Adam on 24.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation


class EmptyStateView: UIView {

    internal static func showUsosDownAlert(inParent view: UIView) {
        EmptyStateView.showAlert(inParent: view, imageName: "empty-state-sunbath", title: "Przerwa w dostępie do USOS", description: "Spróbuj ponownie za jakiś czas :)", descriptionLabelHeight: 30.0, offsetY: 50.0)
    }

    internal static func showNoResultsAlert(inParent view: UIView) {
        EmptyStateView.showAlert(inParent: view, imageName: nil, title: "Brak wyników wyszukiwania", offsetY: 50.0)
    }


    internal static func showAlert(inParent view: UIView, imageName: String?, title: String, description: String? = nil, descriptionLabelHeight: CGFloat = 30.0, offsetY: CGFloat = 0) {
        let width: CGFloat = view.bounds.size.width - 20
        let height: CGFloat = 300
        let originX: CGFloat  = view.bounds.midX - width / 2
        let originY: CGFloat  = view.bounds.midY - height / 2
        let frame = CGRect(x: originX, y: originY, width: width, height: height)

        let container = EmptyStateView(frame: frame)

        container.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]

        if let imageName = imageName {
            let image = EmptyStateView.imageInParentView(container, imageName: imageName, offsetY: offsetY)
            container.addSubview(image)
        }

        let titleLabel = EmptyStateView.titleLabelInParentView(container, title: title, offsetY: offsetY)
        container.addSubview(titleLabel)


        if let description = description,
            let descriptionLabel = EmptyStateView.descriptionLabelInParentView(container, description: description, labelHeight: descriptionLabelHeight, offsetY: offsetY) {
            container.addSubview(descriptionLabel)
        }
        container.alpha = 0.0;
        view.addSubview(container)
        UIView.animate(withDuration: 0.4, animations: {
            container.alpha = 1
        })

        container.perform(#selector(EmptyStateView.hide), with: nil, afterDelay: 5.0)
    }


    private static func imageInParentView(_ view: UIView, imageName: String, offsetY: CGFloat = 0) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        var imageViewFrame = imageView.frame
        let originX: CGFloat = view.bounds.midX - imageView.frame.width / 2
        let originY: CGFloat = offsetY
        imageViewFrame.origin = CGPoint(x: originX, y: originY)
        imageView.frame = imageViewFrame
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        return imageView
    }

    private static func titleLabelInParentView(_ view: UIView, title: String, offsetY: CGFloat = 0) -> UIView {
        var labelFrame = view.bounds
        labelFrame.origin.x = 0
        labelFrame.origin.y = 90 + offsetY
        labelFrame.size = CGSize(width: view.bounds.width, height: 40)

        let label = UILabel(frame: labelFrame)
        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.attributedText = title.toAttributedStringWithFont(UIFont.kjnFontLatoMedium(size: 22)!, color: UIColor.blackWithAlpha(alpha: 0.6))
        return label
    }

    private static func descriptionLabelInParentView(_ view: UIView, description: String? = nil, labelHeight: CGFloat = 30.0, offsetY: CGFloat = 0) -> UIView? {
        guard let description = description else {
            return nil
        }
        var labelFrame = view.bounds
        labelFrame.origin.x = 20
        labelFrame.origin.y = 130 + offsetY
        labelFrame.size = CGSize(width: view.bounds.width - 40, height: labelHeight)

        let label = UILabel(frame: labelFrame)
        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = description.toAttributedStringWithFont(UIFont.kjnFontLatoMedium(size: 17)!, color: UIColor.blackWithAlpha(alpha: 0.6))
        return label
    }

    @objc func hide() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0.0
        }, completion: { t in
            self.removeFromSuperview()
        })
    }

}
