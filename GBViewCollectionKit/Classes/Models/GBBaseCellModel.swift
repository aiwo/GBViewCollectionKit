//
//  GBBaseCellModel.swift
//  Haptic
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

public typealias GBVoidCommand = () -> ()
public typealias GBCellModelCommand = (GBBaseCellModel) -> ()

open class GBBaseCellModel: Any {
    
    private let kDefalutCellHeight: CGFloat = 60.0
    
    public var title: String?
    public var subtitle: String?
    public var cellViewClass: GBCollectionViewCell.Type
    public var onGetImage: (() -> UIImage?)?
    public var onDidSelect: ((GBBaseCellModel) -> ())?
    
    static var referenceCells = [String : GBBaseCollectionViewCell]()
    
    open weak var parent: GBViewCollectionSectionModel?
    
    open var cellHeight: CGFloat {
        get {
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
            
            referenceView.frame = CGRect(x: 0, y: 0, width: 375, height: UILayoutFittingExpandedSize.height)
            
            referenceView.setNeedsLayout()
            referenceView.layoutIfNeeded()
            
            let height = referenceView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height

            return height
        }
    }
    
    public init(title: String? = nil, subtitle: String? = nil, onDidSelect: ((GBBaseCellModel) -> ())? = nil, onGetImage: (() -> UIImage?)? = nil, cellViewClass: GBCollectionViewCell.Type) {
        self.title = title
        self.subtitle = subtitle
        self.cellViewClass = cellViewClass
        self.onDidSelect = onDidSelect
        self.onGetImage = onGetImage
    }
    
    open func configure(_ cell: GBCollectionViewCell) {
        cell.contentTextLabel?.text = self.title
        cell.contentDetailTextLabel?.text = self.subtitle
        if let onGetImage = self.onGetImage {
            cell.contentImageView?.image = onGetImage()
        }
    }
    
    func indexPath() -> IndexPath? {
        guard let section = self.parent,
            let itemIndex = self.parent?.items.index(where: { $0 === self }),
            let sectionIndex = self.parent?.dataSource?.sections.index(where: { $0 === section }) else {
                return nil
        }
        
        return IndexPath(item: itemIndex, section: sectionIndex)
    }
    
    open func cell() -> GBCollectionViewCell? {
        guard let indexPath = self.indexPath() else {
            return nil
        }

        return self.parent?.dataSource?.collectionView?.cellForItem(at: indexPath) as? GBCollectionViewCell
    }
}
