//
//  GBViewCollectionHeaderFooterModel.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 31.01.18.
//

import Foundation

open class GBViewCollectionHeaderFooterModel: Any {
    
    var title: String?
    var subtitle: String?
    var viewClass: GBCollectionViewHeaderFooterView.Type
    
    open var height: CGFloat = 0
    
    public init(title: String? = nil, subtitle: String? = nil, viewClass: GBCollectionViewHeaderFooterView.Type) {
        self.title = title
        self.subtitle = subtitle
        self.viewClass = viewClass
    }
    
    public init(height: CGFloat) {
        self.height = height
        self.viewClass = GBBaseCollectionViewHeaderFooterView.self
    }
    
    open func configure(_ view: GBCollectionViewHeaderFooterView) {
        view.contentTextLabel?.text = self.title
        view.contentDetailTextLabel?.text = self.subtitle
    }
}
