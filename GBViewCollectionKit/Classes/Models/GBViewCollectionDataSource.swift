//
//  GBViewCollectionDataSource.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBViewCollectionDataSource {
    
    var contentView: UIView?
    open var sections = [GBViewCollectionSectionModel]()

    var nextFirstResponderModel: GBBaseCellModel?

    var onScrollToIndexPath: ((IndexPath) -> Void)?
    var onGetIndexPathAtPoint: ((CGPoint) -> IndexPath?)?
    
    var onReloadContentView: (() -> Void)?
    var onReloadSection: ((Int) -> Void)?
    var onReloadItems: (([IndexPath]) -> Void)?
    var onGetCell: ((IndexPath) -> GBCollectionViewCell?)?
    
    var onInsertSectionView: ((GBViewCollectionSectionModel, ((Bool) -> ())?) -> Void)?
    var onInsertCellView: ((GBBaseCellModel, ((Bool) -> ())?) -> Void)?
    var onDeleteSectionView: ((GBViewCollectionSectionModel, ((Bool) -> ())?) -> Void)?
    var onDeleteCellView: ((GBBaseCellModel, ((Bool) -> ())?) -> Void)?
    
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
        onReloadContentView?()
    }
    
    public func reloadSection(at index: Int) {
        onReloadSection?(index)
    }
    
    public func reloadItems(at indexPaths: [IndexPath]) {
        onReloadItems?(indexPaths)
    }
    
    public func cell(for indexPath: IndexPath) -> GBCollectionViewCell? {
        return onGetCell?(indexPath)
    }
    
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
        onInsertSectionView?(section, completion)
    }
    
    public func insert(cellViewOf item: GBBaseCellModel, completion: ((Bool) -> Void)?) {
        onInsertCellView?(item, completion)
    }
    
    public func delete(sectionViewOf section: GBViewCollectionSectionModel, completion: ((Bool) -> Void)?) {
        onDeleteSectionView?(section, completion)
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
        onDeleteCellView?(item, completion)
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
