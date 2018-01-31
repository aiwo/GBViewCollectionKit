//
//  GBCollectionViewCellModel.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

class GBCollectionViewCellModel: NSObject {
    
    private let kDefalutCellHeight: CGFloat = 60.0
    
    var title: String?
    var subtitle: String?
    var cellViewClass: GBCollectionViewCell.Type
    var onDidSelect: ((GBCollectionViewCellModel) -> ())?
    
    var cellHeight: CGFloat {
        get {
            return kDefalutCellHeight
        }
    }
    
    init(title: String? = nil, subtitle: String? = nil, cellViewClass: GBCollectionViewCell.Type, onDidSelect: ((GBCollectionViewCellModel) -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.cellViewClass = cellViewClass
        self.onDidSelect = onDidSelect
        super.init()
    }
    
    func configure(_ cell: GBCollectionViewCell) {
        cell.contentTextLabel?.text = self.title
        cell.contentDetailsTextLabel?.text = self.subtitle
    }
}
