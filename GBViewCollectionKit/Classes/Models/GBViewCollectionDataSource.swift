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
    
    public func reloadItems(at indexPaths: [IndexPath]) {
        if let collectionView = self.collectionView {
            collectionView.reloadItems(at: indexPaths)
        }
    }

}

extension GBViewCollectionDataSource {
    
    public func add(section: GBViewCollectionSectionModel, at index: Int = -1) {
        if index >= 0 {
            sections.insert(section, at: index)
        } else {
            sections.append(section)
        }
        
        section.dataSource = self
    }
    
    public func add(sections: [GBViewCollectionSectionModel]) {
        sections.forEach({ add(section: $0) })
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
    
    public func delete(sectionViewOf section: GBViewCollectionSectionModel, completion: ((Bool) -> Void)?) {
        guard let index = self.sections.index(where: { $0 === section }) else {
            return
        }
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.deleteSections(IndexSet(integer: index))
        }, completion: completion)
    }
    
    /// Removes cell model from the data source as well as its corresponing cell
    /// Unlike insert method, you shouldn't remove cell model from its section's
    /// items array prior to calling this method, because the cell model needs
    /// to still have an indexPath value
    ///
    /// - Parameters:
    ///   - item: cell model to be removed
    ///   - completion: optional completion block
    public func delete(cellViewOf item: GBBaseCellModel, completion: ((Bool) -> Void)?) {
        guard let indexPath = self.indexPath(ofItem: item) else {
            assertionFailure("Cell model object not found anywhere in items array")
            return
        }
        
        self.collectionView?.performBatchUpdates({
            item.section?.remove(item)
            self.collectionView?.deleteItems(at: [indexPath])
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
