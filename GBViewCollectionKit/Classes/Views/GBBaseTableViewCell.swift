//
//  GBBaseTableViewCell.swift
//  GBViewCollectionKit
//
//  Created by Gennadii Berezovskii on 07.10.19.
//

import UIKit

open class GBBaseTableViewCell: UITableViewCell, GBCollectionViewCell {
    
    @IBOutlet public var contentTextLabel: UILabel?
    @IBOutlet public var contentDetailTextLabel: UILabel?
    @IBOutlet public var contentImageView: UIImageView?
    @IBOutlet public var separatorView: UIView?
    
    open var isValid: Bool = true
    open var isEnabled: Bool = true
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupDefaults()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupDefaults()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentImageView?.image = nil
        self.contentTextLabel?.text = ""
        self.contentDetailTextLabel?.text = ""
    }
    
    open func setupDefaults() {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.selectedBackgroundView = view
    }
    
}
