//
//  GBBaseCellModel.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBBaseCellModel: Any {
    
    private let kDefalutCellHeight: CGFloat = 60.0
    
    public var title: String?
    public var subtitle: String?
    public var cellViewClass: GBCollectionViewCell.Type
    public var onGetImage: (() -> UIImage?)?
    public var onDidSelect: ((GBBaseCellModel) -> ())?
    
    var cellHeight: CGFloat {
        get {
            return kDefalutCellHeight
        }
    }
    
    public init(title: String? = nil, subtitle: String? = nil, onDidSelect: ((GBBaseCellModel) -> ())? = nil, onGetImage: (() -> UIImage?)? = nil, cellViewClass: GBCollectionViewCell.Type) {
        self.title = title
        self.subtitle = subtitle
        self.cellViewClass = cellViewClass
        self.onDidSelect = onDidSelect
        self.onGetImage = onGetImage
    }
    
    func configure(_ cell: GBCollectionViewCell) {
        cell.contentTextLabel?.text = self.title
        cell.contentDetailTextLabel?.text = self.subtitle
        if let onGetImage = self.onGetImage {
            cell.contentImageView?.image = onGetImage()
        }
    }
}
