//
//  CollectionViewController.swift
//  GBViewCollectionKitExample
//
//  Created by Gennady Berezovsky on 20.12.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import GBViewCollectionKit

class CollectionViewController: GBDynamicCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
    }


    func setupDataSource() {

        let textFieldExampleCellModel = GBBaseCellModel(title: "Text Fields", subtitle: "A collection view with cells containing UITextFields", onDidSelect: { [weak self] (_) in
            self?.showTextFieldExampleViewController()
        }, onGetImage: { () -> UIImage? in
            return UIImage(named: "icon-phone")
        }, cellViewClass: LabeledCollectionViewCell.self)

        let section = GBViewCollectionSectionModel(items: [textFieldExampleCellModel])
        dataSource = GBViewCollectionDataSource(sections: [section])
    }

    func showTextFieldExampleViewController() {
        performSegue(withIdentifier: "TextFieldsViewControllerSegue", sender: self)
    }

}

