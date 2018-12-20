//
//  TextFieldsViewController.swift
//  GBViewCollectionKitExample
//
//  Created by Gennady Berezovsky on 20.12.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import GBViewCollectionKit

class TextFieldsViewController: GBDynamicCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
    }

    func setupDataSource() {

        var cellModels = [GBBaseCellModel]()

        for _ in (0...5) {
            let cellModel = GBTextFieldCellModel(placeholder: "Placeholder", onGetText: nil, onSetText: { (text) in

            }, cellViewClass: TextFieldCollectionViewCell.self)

            cellModel.onTextFieldDidEndEditing = { (textField, didPressReturn) in
                
            }

            cellModel.onTextFieldShouldChangeCharacters = { (textField, range, string) in

                return true
            }

            cellModel.onTextFieldDidChange = { (textField) in

            }

            cellModels.append(cellModel)
        }

        let section = GBViewCollectionSectionModel(items: cellModels)
        dataSource = GBViewCollectionDataSource(sections: [section])

    }

}
