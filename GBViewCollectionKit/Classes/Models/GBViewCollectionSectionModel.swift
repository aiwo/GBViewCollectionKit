//
//  GBViewCollectionSectionModel.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import Foundation

open class GBViewCollectionSectionModel {
    
    var items = [GBBaseCellModel]()
    public var headerModel: GBViewCollectionHeaderFooterModel?
    public var footerModel: GBViewCollectionHeaderFooterModel?
    public weak var dataSource: GBViewCollectionDataSource?
    
    public var itemsCount: Int {
        return self.items.count
    }
    
    public init() {
        
    }
    
    public init(items: [GBBaseCellModel]) {
        add(items)
    }
    
    public func add(_ item: GBBaseCellModel) {
        add(item, at: items.count)
    }
    
    public func add(_ item: GBBaseCellModel, at index: Int) {
        items.insert(item, at: index)
        item.section = self
    }
    
    public func add(_ items: [GBBaseCellModel]) {
        for item in items {
            add(item)
        }
    }
    
    public func remove(_ item: GBBaseCellModel) {
        self.items = self.items.filter( { $0 !== item } )
        item.section = nil
    }
    
    public func reloadCells(animated: Bool = true) {
        if let dataSource = self.dataSource, let index = dataSource.sections.index(where: { $0 === self }) {
            dataSource.reloadSection(at: index)
        }
    }
    
    public func reloadCellModel(_ cellModel: GBBaseCellModel, animated: Bool = true) {
        if let dataSource = self.dataSource, let indexPath = cellModel.indexPath() {
            dataSource.reloadItems(at: [indexPath])
        }
    }
    
    public func isItemLastInSection(_ item: GBBaseCellModel) -> Bool {
        guard let index = self.items.index(where: { $0 === item }) else {
            return false
        }
        
        return index == self.itemsCount - 1
    }

}
