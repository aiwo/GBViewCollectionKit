//
//  GBTextFieldCollectionViewCell.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 20.12.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import Foundation

public protocol GBTextFieldCollectionViewCell: GBCollectionViewCell {

    var contentTextField: UITextField? { get set }

    var didPressReturn: Bool { get set }

    var onTextFieldShouldChangeCharacters: ((UITextField, NSRange, String) -> Bool)? { get set }
    var onTextFieldDidBeginEditing: ((UITextField) -> Void)? { get set }
    var onTextFieldDidEndEditing: ((UITextField, Bool) -> Void)? { get set }
    var onTextFieldDidChange: ((UITextField) -> Void)? { get set }

}

open class GBBaseTextFieldCollectionViewCell: GBBaseCollectionViewCell, GBTextFieldCollectionViewCell, UITextFieldDelegate {

    @IBOutlet public var contentTextField: UITextField?

    public var didPressReturn = false

    public var onTextFieldShouldChangeCharacters: ((UITextField, NSRange, String) -> Bool)?
    public var onTextFieldDidBeginEditing: ((UITextField) -> Void)?
    public var onTextFieldDidEndEditing: ((UITextField, Bool) -> Void)?
    public var onTextFieldDidChange: ((UITextField) -> Void)?

    override open func setupDefaults() {
        super.setupDefaults()

        contentTextField?.isEnabled = true
        contentTextField?.delegate = self

        onTextFieldDidEndEditing = nil
        contentTextField?.removeTarget(self, action: nil, for: .editingChanged)
        contentTextField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override open func becomeFirstResponder() -> Bool {
        guard let contentTextField = contentTextField else {
            assertionFailure()
            return super.becomeFirstResponder()
        }

        return contentTextField.becomeFirstResponder()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        onTextFieldDidChange?(textField)
    }

    // MARK: UITextFieldDelegate Methods

    public func textFieldDidEndEditing(_ textField: UITextField) {
        onTextFieldDidEndEditing?(textField, didPressReturn)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressReturn = true
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didPressReturn = false
        onTextFieldDidBeginEditing?(textField)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return onTextFieldShouldChangeCharacters?(textField, range, string) ?? true
    }

}
