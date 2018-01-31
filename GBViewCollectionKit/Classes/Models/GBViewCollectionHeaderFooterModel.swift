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
    var viewClass: AnyClass
    
    init(title: String? = nil, subtitle: String? = nil, viewClass: AnyClass) {
        self.title = title
        self.subtitle = subtitle
        self.viewClass = viewClass
    }
}
