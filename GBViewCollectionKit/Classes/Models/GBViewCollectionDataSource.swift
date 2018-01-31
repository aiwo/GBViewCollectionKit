//
//  GBViewCollectionDataSource.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBViewCollectionDataSource: Any {
    
    var collectionView: UICollectionView?
    var sections = [GBViewCollectionSectionModel]()

    public init(sections: [GBViewCollectionSectionModel]) {
        self.sections = sections
    }
    
    public func item(from indexPath: IndexPath) -> GBBaseCellModel? {
        guard indexPath.section < self.sections.count else {
            return nil
        }
        let section = self.sections[indexPath.section]
        
        guard indexPath.row < section.items.count else {
            return nil
        }
        
        return section.items[indexPath.row]
    }
    
    public func reloadContentView() {
        if let collectionView = self.collectionView {
            collectionView.reloadData()
        }
    }

}
