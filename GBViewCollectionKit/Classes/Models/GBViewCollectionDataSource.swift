//
//  GBViewCollectionDataSource.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBViewCollectionDataSource {
    
    var collectionView: UICollectionView?
    open var sections = [GBViewCollectionSectionModel]()

    var nextFirstResponderModel: GBBaseCellModel?

    var onScrollToIndexPath: ((IndexPath) -> Void)?
    var onGetIndexPathAtPoint: ((CGPoint) -> IndexPath?)?
    
    public init() {
        self.setupSections()
    }
    
    open func setupSections() {
        
    }

    public init(sections: [GBViewCollectionSectionModel]) {
        sections.forEach { (section) in
            section.dataSource = self
        }
        
        self.sections = sections
    }
    
    public func reloadContentView() {
        if let collectionView = self.collectionView {
            collectionView.reloadData()
        }
    }
    
    public func reloadSection(at index: Int) {
        if let collectionView = self.collectionView {
            collectionView.reloadSections(IndexSet(integer: index))
        }
    }

}

extension GBViewCollectionDataSource {
    
    public func add(section: GBViewCollectionSectionModel) {
        self.sections.append(section)
    }
    
    public func add(sections: [GBViewCollectionSectionModel]) {
        for section in sections {
            self.sections.append(section)
            section.dataSource = self
        }
    }
    
    public func remove(section: GBViewCollectionSectionModel) {
        self.sections = self.sections.filter { $0 !== section }
    }
    
    public func insert(sectionViewOf section: GBViewCollectionSectionModel, completion: ((Bool) -> Void)?) {
        guard let index = self.sections.index(where: { $0 === section }) else {
            return
        }
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertSections(IndexSet(integer: index))
        }, completion: completion)
    }
    
    public func insert(cellViewOf item: GBBaseCellModel, completion: ((Bool) -> Void)?) {
        guard let indexPath = self.indexPath(ofItem: item) else {
            return
        }
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [indexPath])
        }, completion: completion)
    }
    
}

extension GBViewCollectionDataSource {

    public func itemFor(row: Int, section: Int) -> GBBaseCellModel? {
        guard section < sections.count else {
            return nil
        }
        let section = sections[section]

        guard row < section.items.count else {
            return nil
        }

        return section.items[row]
    }

    public func itemFrom(_ indexPath: IndexPath) -> GBBaseCellModel? {
        return itemFor(row: indexPath.row, section: indexPath.section)
    }
    
    public func section(from indexPath: IndexPath) -> GBViewCollectionSectionModel? {
        guard indexPath.section < self.sections.count else {
            return nil
        }
        return self.sections[indexPath.section]
    }
    
    func indexPath(ofItem item: GBBaseCellModel) -> IndexPath? {
        for section in self.sections {
            if let itemIndex = section.items.index(where: { $0 === item }),
                let sectionIndex = self.sections.index(where: { $0 === section }) {
                return IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
        
        return nil
    }
    
}
