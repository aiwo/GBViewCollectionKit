//
//  GBCollectionViewDataSource.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

class GBCollectionViewDataSource: NSObject {
    
    var collectionView: UICollectionView?
    var sections = [GBCollectionViewSectionModel]()

    init(sections: [GBCollectionViewSectionModel]) {
        self.sections = sections
        super.init()
    }
    
    func item(from indexPath: IndexPath) -> GBCollectionViewCellModel? {
        guard indexPath.section < self.sections.count else {
            return nil
        }
        let section = self.sections[indexPath.section]
        
        guard indexPath.row < section.items.count else {
            return nil
        }
        
        return section.items[indexPath.row]
    }
    
    func reloadContentView() {
        if let collectionView = self.collectionView {
            collectionView.reloadData()
        }
    }

}
