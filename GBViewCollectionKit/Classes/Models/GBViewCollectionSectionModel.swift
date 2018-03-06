//
//  GBViewCollectionSectionModel.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import Foundation

open class GBViewCollectionSectionModel: Any {
    
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
        self.add(items)
    }
    
    public func add(_ item: GBBaseCellModel) {
        self.items.append(item)
        item.parent = self
    }
    
    public func add(_ items: [GBBaseCellModel]) {
        for item in items {
            self.add(item)
        }
    }
    
    public func remove(item: GBBaseCellModel) {
        self.items = self.items.filter( { $0 !== item } )
        item.parent = nil
    }
    
    public func reloadCells(animated: Bool = true) {
        if let dataSource = self.dataSource, let index = dataSource.sections.index(where: { $0 === self }) {
            dataSource.reloadSection(at: index)
        }
    }

}
