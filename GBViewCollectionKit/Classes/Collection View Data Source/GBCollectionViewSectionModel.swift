//
//  GBCollectionViewSectionModel.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import Foundation

class GBCollectionViewSectionModel: NSObject {
    
    var items = [GBCollectionViewCellModel]()
    
    init(items: [GBCollectionViewCellModel]) {
        self.items = items
        super.init()
    }
    
    func add(_ item: GBCollectionViewCellModel) {
        self.items.append(item)
    }
    
    func add(_ items: [GBCollectionViewCellModel]) {
        for item in items {
            self.add(item)
        }
    }
    
    func remove(item: GBCollectionViewCellModel) {
        self.items = self.items.filter( { $0 != item } )
    }

}
