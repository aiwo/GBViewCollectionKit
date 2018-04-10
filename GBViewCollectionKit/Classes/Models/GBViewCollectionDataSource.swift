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
    open var sections = [GBViewCollectionSectionModel]()
    
    public init() {
        self.setupSections()
    }
    
    open func setupSections() {
        
    }

    public init(sections: [GBViewCollectionSectionModel]) {
        self.sections = sections
    }
    
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
    
    public func section(from indexPath: IndexPath) -> GBViewCollectionSectionModel? {
        guard indexPath.section < self.sections.count else {
            return nil
        }
        return self.sections[indexPath.section]
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
