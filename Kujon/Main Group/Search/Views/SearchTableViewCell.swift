//
//  SearchTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate:class {

    func searchTableViewCell(cell: SearchTableViewCell, didTriggerSearchWithQuery searchQuery:String)
    func searchTableViewCellDidChangeSelection()
}

internal class SearchTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet internal weak var button: UIButton!
    @IBOutlet internal weak var title: UILabel!
    @IBOutlet internal weak var separator: UIView!
    @IBOutlet internal weak var textField: UITextField!
    private var searchQuery = String()
    internal weak var delegate: SearchTableViewCellDelegate?
    internal var index: Int = 0

    // MARK: Initial section

    override internal func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        configureSearchButton()
        updateSeparatorColor()
        updateSearchButtonState()

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        textField.text = ""

    }

    private func configureSearchButton() {
        let title = StringHolder.searchButtonLabel

        let titleForStateEnabled = title.attributedStringWithFont(UIFont.kjnFontLatoMedium(size:17)!, color: UIColor.color3FBAD9(alpha: 1.0))
        button.setAttributedTitle(titleForStateEnabled, forState: .Normal)

        let titleForStateDisabled = title.attributedStringWithFont(UIFont.kjnFontLatoMedium(size:17)!, color: UIColor.color3FBAD9(alpha: 0.4))
        button.setAttributedTitle(titleForStateDisabled, forState: .Disabled)
    }

    internal func configureCellWithTitle(cellTitle:String, textInputPlaceholder placeholder:String) {

        title.attributedText = cellTitle.attributedStringWithFont(UIFont.kjnFontLatoRegular(size:17)!, color: UIColor.color2A333E())

        textField.attributedPlaceholder = placeholder.attributedStringWithFont(UIFont.kjnFontLatoRegular(size:15)!, color: UIColor.color000000(alpha: 0.35))

        textField.placeholder = placeholder
    }

    // MARK: User actions

    override internal func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        delegate?.searchTableViewCellDidChangeSelection()
        updateSeparatorColor()
    }

    @IBAction internal func searchButtonDidTap(sender: UIButton) {
        if !searchQuery.isEmpty {
            delegate?.searchTableViewCell(self, didTriggerSearchWithQuery: searchQuery)
        }
    }

    private func updateSeparatorColor() {
        separator.backgroundColor = selected ? .color3FBAD9() : .colorD8D8D8()
    }

    internal func reset() {
        separator.backgroundColor = .colorD8D8D8()
        updateSearchButtonState()
    }

    // MARK: UITextFieldDelegate

    internal func textFieldDidBeginEditing(textField: UITextField) {
        textField.font = UIFont.kjnFontLatoRegular(size:15.0)
        textField.textColor = UIColor.color2A333E()
        textField.text = searchQuery
        selected = true
    }

    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !searchQuery.isEmpty {
            delegate?.searchTableViewCell(self, didTriggerSearchWithQuery: searchQuery)
        }
        return true
    }

    internal func textFieldDidChange(textField:UITextField) {
        if let text = textField.text {
            searchQuery = text
            updateSearchButtonState()
        }
    }

    private func updateSearchButtonState() {
        button.enabled = !searchQuery.isEmpty
    }

}