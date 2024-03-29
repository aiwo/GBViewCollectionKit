//
//  GBDynamicCollectionViewController.swift
//  GBViewCollectionKit
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBDynamicCollectionViewController: UICollectionViewController {
    
    var registeredClasses = [AnyClass]()
    
    open var dataSource: GBViewCollectionDataSource? {
        didSet {
            dataSource?.contentView = collectionView

            setupCommands()

            self.collectionView?.reloadData()
        }
    }

    func setupCommands() {
        dataSource?.onScrollToIndexPath = { [weak self] (indexPath) in
            self?.collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        }

        dataSource?.onGetIndexPathAtPoint = { [weak self] (point) in
            return self?.collectionView?.indexPathForItem(at: point)
        }
        
        dataSource?.onInsertCellView = { [weak self] (item, completion) in
            guard let indexPath = self?.dataSource?.indexPath(ofItem: item) else {
                return
            }
            
            self?.collectionView?.performBatchUpdates({
                self?.collectionView?.insertItems(at: [indexPath])
            }, completion: completion)
        }
        
        dataSource?.onInsertSectionView = { [weak self] (section, completion) in
            guard let index = self?.dataSource?.sections.index(where: { $0 === section }) else {
                return
            }
            
            self?.collectionView?.performBatchUpdates({
                self?.collectionView?.insertSections(IndexSet(integer: index))
            }, completion: completion)
        }
        
        dataSource?.onDeleteCellView = { [weak self] (item, completion) in
            guard let indexPath = self?.dataSource?.indexPath(ofItem: item) else {
                assertionFailure("Cell model object not found anywhere in items array")
                return
            }
            
            self?.collectionView?.performBatchUpdates({
                item.section?.remove(item)
                self?.collectionView?.deleteItems(at: [indexPath])
            }, completion: completion)
        }
        
        dataSource?.onDeleteSectionView = { [weak self] (section, completion) in
            guard let index = self?.dataSource?.sections.index(where: { $0 === section }) else {
                return
            }
            
            self?.collectionView?.performBatchUpdates({
                self?.collectionView?.deleteSections(IndexSet(integer: index))
            }, completion: completion)
        }
        
        dataSource?.onReloadContentView = { [weak self] in
            self?.collectionView?.reloadData()
        }
        
        dataSource?.onReloadItems = { [weak self] (indexPaths) in
            self?.collectionView?.reloadItems(at: indexPaths)
        }
        
        dataSource?.onReloadSection = { [weak self] (index) in
            self?.collectionView?.reloadSections(IndexSet(integer: index))
        }
        
        dataSource?.onGetCell = { [weak self] (indexPath) in
            return self?.collectionView?.cellForItem(at: indexPath) as? GBCollectionViewCell
        }
    }
}

extension GBDynamicCollectionViewController {
    
    func registerNib(forCellClass cellClass: AnyClass, collectionView: UICollectionView) {
        if !self.registeredClasses.filter({ $0 == cellClass }).isEmpty {
            return
        }
        
        let reuseIdentifier = String(describing: cellClass)
        let nib = UINib.init(nibName: reuseIdentifier, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.registeredClasses.append(cellClass)
    }
    
    func registerNib(forHeaderFooterViewClass viewClass: AnyClass, collectionView: UICollectionView) {
        if !self.registeredClasses.filter({ $0 == viewClass }).isEmpty {
            return
        }
        
        let reuseIdentifier = String(describing: viewClass)
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: viewClass))
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        
        self.registeredClasses.append(viewClass)
    }
    
}

extension GBDynamicCollectionViewController {
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.sections.count
    }
    
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        let section = dataSource.sections[section]
        return section.items.count
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = self.dataSource, let item = dataSource.itemFrom(indexPath) else {
            return UICollectionViewCell()
        }
        
        self.registerNib(forCellClass: item.cellViewClass as AnyClass, collectionView: collectionView)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: item.cellViewClass), for: indexPath) as? GBBaseCollectionViewCell {
            item.configure(cell)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let dataSource = self.dataSource, let section = dataSource.section(from: indexPath), let headerModel = section.headerModel else {
            return UICollectionReusableView()
        }
        
        self.registerNib(forHeaderFooterViewClass: headerModel.viewClass as! AnyClass, collectionView: collectionView)
        
        let reuseIdentifier = String(describing: headerModel.viewClass)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier, for: indexPath) as! GBBaseCollectionViewHeaderFooterView
        headerModel.configure(view)
        
        return view
    }
    
    override open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = 0.0
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource, let item = dataSource.itemFrom(indexPath) else {
            return
        }
        
        item.onDidSelect?(item)
    }
    
}

extension GBDynamicCollectionViewController: UICollectionViewDelegateFlowLayout {

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let dataSource = self.dataSource, let item = dataSource.itemFrom(indexPath) else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        
        return CGSize(width: collectionView.frame.width, height: item.cellHeight(forWidth: collectionView.frame.width))
    }
    
    open override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let dataSource = self.dataSource, let item = dataSource.itemFrom(indexPath) else {
            return false
        }
        
        return item.onDidSelect != nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let dataSource = self.dataSource, let headerModel = dataSource.sections[section].headerModel else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        
        return CGSize(width: collectionView.frame.width, height: headerModel.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
