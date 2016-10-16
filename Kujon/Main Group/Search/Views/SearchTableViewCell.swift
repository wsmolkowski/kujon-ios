//
//  SearchTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate:class {

    func searchTableViewCell(_ cell: SearchTableViewCell, didTriggerSearchWithQuery searchQuery:String)
    func searchTableViewCellDidChangeSelection()
}

internal class SearchTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet internal weak var button: UIButton!
    @IBOutlet internal weak var title: UILabel!
    @IBOutlet internal weak var separator: UIView!
    @IBOutlet internal weak var textField: UITextField!
    internal weak var delegate: SearchTableViewCellDelegate?
    internal var index: Int = 0
    fileprivate var searchQuery = String()
    fileprivate let searchQueryMinimumLength: Int = 4
    fileprivate var canTriggerQuery: Bool {
        return searchQuery.characters.count >= searchQueryMinimumLength
    }
    // MARK: Initial section

    override internal func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureSearchButton()
        updateSeparatorColor()
        updateSearchButtonState()

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.text = ""
        textField.clearButtonMode = .whileEditing

    }

    fileprivate func configureSearchButton() {
        let title = StringHolder.searchButtonLabel

        let titleForStateEnabled = title.toAttributedStringWithFont(UIFont.kjnFontLatoMedium(size:17)!, color: UIColor.color3FBAD9(alpha: 1.0))
        button.setAttributedTitle(titleForStateEnabled, for: UIControlState())

        let titleForStateDisabled = title.toAttributedStringWithFont(UIFont.kjnFontLatoMedium(size:17)!, color: UIColor.color3FBAD9(alpha: 0.4))
        button.setAttributedTitle(titleForStateDisabled, for: .disabled)
    }

    internal func configureCellWithTitle(_ cellTitle:String, textInputPlaceholder placeholder:String) {

        title.attributedText = cellTitle.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size:17)!, color: UIColor.color2A333E())

        textField.attributedPlaceholder = placeholder.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size:15)!, color: UIColor.color000000(alpha: 0.35))

        textField.placeholder = placeholder
    }

    // MARK: User actions

    override internal func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        delegate?.searchTableViewCellDidChangeSelection()
        updateSeparatorColor()
    }

    @IBAction internal func searchButtonDidTap(_ sender: UIButton) {
        if !searchQuery.isEmpty {
            delegate?.searchTableViewCell(self, didTriggerSearchWithQuery: searchQuery)
        }
    }

    fileprivate func updateSeparatorColor() {
        separator.backgroundColor = isSelected ? .color3FBAD9() : .colorD8D8D8()
    }

    internal func reset() {
        separator.backgroundColor = .colorD8D8D8()
        updateSearchButtonState()
    }

    // MARK: UITextFieldDelegate

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.font = UIFont.kjnFontLatoRegular(size:15.0)
        textField.textColor = UIColor.color2A333E()
        textField.text = searchQuery
        isSelected = true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if canTriggerQuery {
            delegate?.searchTableViewCell(self, didTriggerSearchWithQuery: searchQuery)
            textField.resignFirstResponder()
            return true
        }
        return false
    }

    internal func textFieldDidChange(_ textField:UITextField) {
        if let text = textField.text {
            searchQuery = text
            updateSearchButtonState()
        }
    }

    fileprivate func updateSearchButtonState() {
        button.isEnabled = canTriggerQuery
    }



}
