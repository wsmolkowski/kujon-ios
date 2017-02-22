//
//  AccessoryItemCell
//  Kujon
//
//  Created by Adam on 09.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class AccessoryItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    enum CellStyle {
        case arrowRight
        case checkbox
        case plain
    }

    private var separatorPosition: UIRectEdge = [] {
        didSet {

            let separatorColor = UIColor.lightGray()
            layer.addBorder(separatorPosition, color:separatorColor, thickness:1)
            accessoryView?.layer.addBorder(separatorPosition, color:separatorColor, thickness:1)
        }
    }

    private var cellStyle: CellStyle = .plain {
        didSet {
            switch cellStyle {
            case .arrowRight:
                accessoryType = .disclosureIndicator
            case .checkbox:
                accessoryType = .checkmark
            case .plain:
                accessoryType = .none
            }
        }
    }


    override internal func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .none
    }

    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }

    internal func setStyle( _ style:CellStyle, separatorPosition position:UIRectEdge = .top) {
        cellStyle = style
        separatorPosition = position
    }

    // MARK: Handle checkbox cell style

    internal var isChecked: Bool = false {
        didSet {
            guard cellStyle == .checkbox else { return }
            accessoryType = isChecked ? .checkmark : .none
        }
    }

    internal func toggle() {
        guard cellStyle == .checkbox else { return }
        isChecked = !isChecked
    }

}
