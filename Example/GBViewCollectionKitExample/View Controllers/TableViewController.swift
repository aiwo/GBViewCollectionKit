//
//  TableViewController.swift
//  GBViewCollectionKitExample
//
//  Created by Gennadii Berezovskii on 07.10.19.
//  Copyright © 2019 Gennady Berezovsky. All rights reserved.
//

import GBViewCollectionKit

class TableViewController: GBDynamicTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
    }
    
    
    func setupDataSource() {
        
        let items = (0..<10).map({ (_) -> GBBaseCellModel in
            let originalContent = "This is a content string which is supposed to occupy multiple lines"
            let randomizedContent = (0...(arc4random() % 8)).reduce("") { (result, _) -> String in
                return result + originalContent
            }

            return GBBaseCellModel(title: "Some title", subtitle: randomizedContent, onDidSelect: nil, onGetImage: nil, cellViewClass: TableViewCell.self)
        })
        
        let section = GBViewCollectionSectionModel(items: items)
        dataSource = GBViewCollectionDataSource(sections: [section])
    }
    
}
