//
//  GBTextFieldCellModel.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 20.12.18.
//

import Foundation

class GBTextFieldCellModel: GBBaseCellModel {

    var placeholder: String?
    var text: String?
    var onGetText: (() -> String?)?
    var onSetText: ((String?) -> Void)?

    var tapOutsideGestureRecognizer: UITapGestureRecognizer?

    var onTextFieldShouldChangeCharacters: ((UITextField, NSRange, String) -> Bool)?
    var onTextFieldDidBeginEditing: ((UITextField) -> Void)?
    var onTextFieldDidEndEditing: ((UITextField, Bool) -> Void)?
    var onTextFieldDidChange: ((UITextField) -> Void)?

    init(placeholder: String?, onGetText: (() -> String?)?, onSetText: ((String?) -> Void)?, cellViewClass: GBTextFieldCollectionViewCell.Type) {
        self.placeholder = placeholder?.uppercased()
        self.onGetText = onGetText
        self.onSetText = onSetText

        super.init(cellViewClass: cellViewClass)
    }

    func nextEnabledTextFieldModel() -> GBTextFieldCellModel? {
        guard let section = section,
            let dataSource = section.dataSource else {
                return nil
        }

        let currentSectionIndex = dataSource.sections.firstIndex(where: { (section) -> Bool in
            return section === self.section
        })
        let currentRowIndex = section.items.firstIndex(where: { (cellModel) -> Bool in
            return cellModel === self
        })

        guard let currentSectionIndexUnwrapped = currentSectionIndex, let currentRowIndexUnwrapped = currentRowIndex else {
            return nil
        }

        for sectionIndex in (currentSectionIndexUnwrapped..<dataSource.sections.count) {
            let startRowIndex = (sectionIndex > currentSectionIndexUnwrapped) ? 0 : currentRowIndexUnwrapped + 1
            for rowIndex in (startRowIndex..<section.items.count) {
                guard let model = dataSource.itemFor(row: rowIndex, section: sectionIndex) else {
                    return nil
                }
                if model.isEnabled, model is GBTextFieldCellModel {
                    return model as? GBTextFieldCellModel
                }
            }
        }

        return nil;
    }

    override func configure(_ cell: GBCollectionViewCell) {
        super.configure(cell)

        guard let textFieldCell = cell as? GBTextFieldCollectionViewCell else {
            assertionFailure()
            return
        }

        textFieldCell.contentTextField?.placeholder = placeholder
        textFieldCell.contentTextField?.text = onGetText?()

        textFieldCell.onTextFieldDidEndEditing = { [weak self] (textField, didPressReturn) in
            guard let self = self else {
                return
            }

            self.text = textField.text

            self.reloadCellValidity()
            if didPressReturn {
                let nextModel = self.nextEnabledTextFieldModel()
                nextModel?.becomeFirstResponder()
            }
            self.onTextFieldDidEndEditing?(textField, didPressReturn)
            if let tapOutsideGestureRecognizer = self.tapOutsideGestureRecognizer {
                self.section?.dataSource?.collectionView?.removeGestureRecognizer(tapOutsideGestureRecognizer)
            }
        }

        textFieldCell.onTextFieldDidBeginEditing = { [weak self] (textField) in
            guard let self = self else {
                return
            }

            if self.tapOutsideGestureRecognizer == nil {
                self.tapOutsideGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutside(_:)))
                self.tapOutsideGestureRecognizer?.delegate = self
            }
            guard let tapOutsideGestureRecognizer = self.tapOutsideGestureRecognizer else {
                assertionFailure()
                return
            }

            self.section?.dataSource?.collectionView?.addGestureRecognizer(tapOutsideGestureRecognizer)
        }

        textFieldCell.onTextFieldShouldChangeCharacters = { [weak self] (textField, range, string) in
            guard let self = self else {
                return true
            }

            return self.onTextFieldShouldChangeCharacters?(textField, range, string) ?? true
        }

        textFieldCell.onTextFieldDidChange = { [weak self] (textField) in
            guard let self = self,
                let onTextFieldDidChange = self.onTextFieldDidChange else {
                return
            }

            self.text = textField.text
            onTextFieldDidChange(textField)
        }

    }

    @objc func handleTapOutside(_ recognizer: UIGestureRecognizer) {
        guard let textFieldCell = cell() as? GBTextFieldCollectionViewCell else {
            return
        }

        text = textFieldCell.contentTextField?.text
        section?.dataSource?.collectionView?.endEditing(true)
        if let tapOutsideGestureRecognizer = tapOutsideGestureRecognizer {
            section?.dataSource?.collectionView?.removeGestureRecognizer(tapOutsideGestureRecognizer)
        }
    }

}

extension GBTextFieldCellModel: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        handleTapOutside(gestureRecognizer)
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: section?.dataSource?.collectionView)
        guard let indexPath = section?.dataSource?.onGetIndexPathAtPoint?(point),
            let currentIndexPath = self.indexPath() else {
            return true
        }

        return indexPath.compare(currentIndexPath) != .orderedSame
    }

}
