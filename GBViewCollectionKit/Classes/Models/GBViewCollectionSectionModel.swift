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
    
    public init() {
        
    }
    
    public init(items: [GBBaseCellModel]) {
        self.items = items
    }
    
    public func add(_ item: GBBaseCellModel) {
        self.items.append(item)
    }
    
    public func add(_ items: [GBBaseCellModel]) {
        for item in items {
            self.add(item)
        }
    }
    
    public func remove(item: GBBaseCellModel) {
        self.items = self.items.filter( { $0 !== item } )
    }

}
