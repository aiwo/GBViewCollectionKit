//
//  GBBaseCollectionViewCell.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

public protocol GBCollectionViewCell {
    weak var contentTextLabel: UILabel? { get set }
    weak var contentDetailTextLabel: UILabel? { get set }
    weak var contentImageView: UIImageView? { get set }
}

open class GBBaseCollectionViewCell: UICollectionViewCell, GBCollectionViewCell {
    
    @IBOutlet public var contentTextLabel: UILabel?
    @IBOutlet public var contentDetailTextLabel: UILabel?
    @IBOutlet public var contentImageView: UIImageView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
