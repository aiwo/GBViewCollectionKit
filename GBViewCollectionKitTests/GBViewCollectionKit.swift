//
//  GBCollectionViewKitTests.swift
//  GBCollectionViewKitTests
//
//  Created by Gennady Berezovsky on 31.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import XCTest
@testable import GBViewCollectionKit

class GBCollectionViewKitTests: XCTestCase {
    
    func testAddItem() {
        let section = GBViewCollectionSectionModel()
        let item = GBBaseCellModel(cellViewClass: GBBaseCollectionViewCell.self)
        section.add(item)
        XCTAssertEqual(section.items.count, 1)
    }
    
}
