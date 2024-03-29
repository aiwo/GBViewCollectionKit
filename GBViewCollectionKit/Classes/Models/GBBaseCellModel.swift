//
//  GBBaseCellModel.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBBaseCellModel: NSObject {
    
    private let kDefalutCellHeight: CGFloat = 60.0
    
    public var title: String?
    public var subtitle: String?
    public var cellViewClass: GBCollectionViewCell.Type
    public var onGetImage: (() -> UIImage?)?
    public var onDidSelect: ((GBBaseCellModel) -> Void)?
    public var onGetIsEnabled: (() -> (Bool))?
    public var onGetIsValid: (() -> (Bool))?

    var isEnabled: Bool {
        return onGetIsEnabled?() ?? true
    }

    var shouldValidate: Bool = true
    var isValid: Bool {
        return onGetIsValid?() ?? true
    }
    
    public var isLastInSection: Bool {
        return section?.items.last === self
    }
    
    static var referenceCells = [String : GBBaseCollectionViewCell]()
    
    open weak var section: GBViewCollectionSectionModel?
    
    public init(title: String? = nil, subtitle: String? = nil, onDidSelect: ((GBBaseCellModel) -> Void)? = nil, onGetImage: (() -> UIImage?)? = nil, cellViewClass: GBCollectionViewCell.Type) {
        self.title = title
        self.subtitle = subtitle
        self.cellViewClass = cellViewClass
        self.onDidSelect = onDidSelect
        self.onGetImage = onGetImage
    }
    
    open func cellHeight(forWidth width: CGFloat) -> CGFloat {
        let cellClassString = String(describing: self.cellViewClass)
        if GBBaseCellModel.referenceCells[cellClassString] == nil {
            guard let newReferenceView = Bundle.main.loadNibNamed(cellClassString, owner: nil, options: nil)?.first as? GBBaseCollectionViewCell else {
                return kDefalutCellHeight
            }
            GBBaseCellModel.referenceCells[cellClassString] = newReferenceView
        }
        
        guard let referenceView = GBBaseCellModel.referenceCells[cellClassString] else {
            return kDefalutCellHeight
        }
        
        self.configure(referenceView)
        
        referenceView.setNeedsUpdateConstraints()
        referenceView.updateConstraints()
        
        referenceView.frame = CGRect(x: 0, y: 0, width: width, height: UIView.layoutFittingExpandedSize.height)
        
        referenceView.setNeedsLayout()
        referenceView.layoutIfNeeded()
        
        let height = referenceView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        return height
    }
    
    open func configure(_ cell: GBCollectionViewCell) {
        cell.contentTextLabel?.text = self.title
        cell.contentDetailTextLabel?.text = self.subtitle
        if let onGetImage = self.onGetImage {
            cell.contentImageView?.image = onGetImage()
        }
        
        cell.separatorView?.isHidden = isLastInSection
        if shouldValidate {
            cell.isValid = isValid
        }
        cell.isEnabled = isEnabled
    }
    
    public func indexPath() -> IndexPath? {
        guard let section = self.section,
            let itemIndex = self.section?.items.index(where: { $0 === self }),
            let sectionIndex = self.section?.dataSource?.sections.index(where: { $0 === section }) else {
                return nil
        }
        
        return IndexPath(item: itemIndex, section: sectionIndex)
    }
    
    public func cell() -> GBCollectionViewCell? {
        guard let indexPath = self.indexPath() else {
            return nil
        }
        
        return section?.dataSource?.onGetCell?(indexPath)
    }
    
    public func reloadCell() {
        guard let cell = cell() else {
            assertionFailure()
            return
        }
        
        configure(cell)
    }

    public func reloadCellValidity() {
        cell()?.isValid = isValid
    }

    open func becomeFirstResponder() {
        guard let cell = cell() as? UICollectionViewCell else {
            section?.dataSource?.nextFirstResponderModel = self
            return
        }

        cell.becomeFirstResponder()
        section?.dataSource?.nextFirstResponderModel = nil

        guard let indexPath = indexPath() else {
            return
        }

        section?.dataSource?.onScrollToIndexPath?(indexPath)
    }
}
