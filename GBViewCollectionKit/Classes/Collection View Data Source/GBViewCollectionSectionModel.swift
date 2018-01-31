//
//  GBViewCollectionSectionModel.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import Foundation

class GBViewCollectionSectionModel: NSObject {
    
    var items = [GBBaseCellModel]()
    
    override init() {
        super.init()
    }
    
    init(items: [GBBaseCellModel]) {
        self.items = items
        super.init()
    }
    
    func add(_ item: GBBaseCellModel) {
        self.items.append(item)
    }
    
    func add(_ items: [GBBaseCellModel]) {
        for item in items {
            self.add(item)
        }
    }
    
    func remove(item: GBBaseCellModel) {
        self.items = self.items.filter( { $0 != item } )
    }

}
