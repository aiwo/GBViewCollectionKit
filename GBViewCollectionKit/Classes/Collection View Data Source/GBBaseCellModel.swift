//
//  GBBaseCellModel.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

class GBBaseCellModel: Any {
    
    private let kDefalutCellHeight: CGFloat = 60.0
    
    var title: String?
    var subtitle: String?
    var cellViewClass: GBCollectionViewCell.Type
    var onDidSelect: ((GBBaseCellModel) -> ())?
    
    var cellHeight: CGFloat {
        get {
            return kDefalutCellHeight
        }
    }
    
    init(title: String? = nil, subtitle: String? = nil, cellViewClass: GBCollectionViewCell.Type, onDidSelect: ((GBBaseCellModel) -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.cellViewClass = cellViewClass
        self.onDidSelect = onDidSelect
    }
    
    func configure(_ cell: GBCollectionViewCell) {
        cell.contentTextLabel?.text = self.title
        cell.contentDetailsTextLabel?.text = self.subtitle
    }
}
