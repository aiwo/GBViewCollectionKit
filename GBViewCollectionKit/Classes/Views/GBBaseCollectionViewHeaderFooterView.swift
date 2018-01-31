//
//  GBBaseCollectionViewHeaderFooterView.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 31.01.18.
//

import UIKit

public protocol GBCollectionViewHeaderFooterView {
    weak var contentTextLabel: UILabel? { get set }
    weak var contentDetailTextLabel: UILabel? { get set }
    weak var contentImageView: UILabel? { get set }
}

open class GBBaseCollectionViewHeaderFooterView: UICollectionReusableView, GBCollectionViewHeaderFooterView {
    @IBOutlet public var contentTextLabel: UILabel?
    @IBOutlet public var contentDetailTextLabel: UILabel?
    @IBOutlet public var contentImageView: UILabel?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupDefaults()
    }
    
    public func setupDefaults() {
        
    }
}
