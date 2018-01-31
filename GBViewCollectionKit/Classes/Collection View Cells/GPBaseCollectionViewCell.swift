//
//  GPBaseCollectionViewCell.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

protocol GBCollectionViewCell {
    weak var contentTextLabel: UILabel? { get set }
    weak var contentDetailsTextLabel: UILabel? { get set }
    weak var contentImageView: UILabel? { get set }
}

class GPBaseCollectionViewCell: UICollectionViewCell, GBCollectionViewCell {
    @IBOutlet var contentTextLabel: UILabel?
    @IBOutlet var contentDetailsTextLabel: UILabel?
    @IBOutlet var contentImageView: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupDefaults()
    }
    
    func setupDefaults() {
        
    }
}
