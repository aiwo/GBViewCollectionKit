//
//  GBTextFieldCollectionViewCell.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 20.12.18.
//

import Foundation

protocol GBTextFieldCollectionViewCell: GBCollectionViewCell {

    var contentTextField: UITextField? { get set }

    var didPressReturn: Bool { get set }

    var onTextFieldShouldChangeCharacters: ((UITextField, NSRange, String) -> Bool)? { get set }
    var onTextFieldDidBeginEditing: ((UITextField) -> Void)? { get set }
    var onTextFieldDidEndEditing: ((UITextField, Bool) -> Void)? { get set }
    var onTextFieldDidChange: ((UITextField) -> Void)? { get set }

}

class GBBaseTextFieldCollectionViewCell: GBBaseCollectionViewCell {

    @IBOutlet public var contentTextField: UITextField!

    var didPressReturn = false

    var onTextFieldShouldChangeCharacters: ((UITextField, NSRange, String) -> Bool)?
    var onTextFieldDidBeginEditing: ((UITextField) -> Void)?
    var onTextFieldDidEndEditing: ((UITextField, Bool) -> Void)?
    var onTextFieldDidChange: ((UITextField) -> Void)?

    override func setupDefaults() {
        super.setupDefaults()

        contentTextField.isEnabled = true
        contentTextField.delegate = self

        onTextFieldDidEndEditing = nil
        contentTextField.removeTarget(self, action: nil, for: .editingChanged)
        contentTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func becomeFirstResponder() -> Bool {
        return contentTextField.becomeFirstResponder()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        onTextFieldDidChange?(textField)
    }

}

extension GBBaseTextFieldCollectionViewCell: UITextFieldDelegate {


    func textFieldDidEndEditing(_ textField: UITextField) {
        onTextFieldDidEndEditing?(textField, didPressReturn)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressReturn = true
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        didPressReturn = false
        onTextFieldDidBeginEditing?(textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return onTextFieldShouldChangeCharacters?(textField, range, string) ?? true
    }

}
