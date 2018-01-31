//
//  GBDynamicCollectionViewController.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBDynamicCollectionViewController: UICollectionViewController {
    
    var registeredClasses = [AnyClass]()
    
    public var dataSource: GBViewCollectionDataSource? {
        didSet {
            self.registerCells()
            dataSource?.collectionView = self.collectionView
            self.collectionView?.reloadData()
        }
    }
}

extension GBDynamicCollectionViewController {
    
    func registerCells() {
        guard let dataSource = self.dataSource else {
            return
        }
        
        for section in dataSource.sections {
            for item in section.items {
                
                self.collectionView?.register(item.cellViewClass as? AnyClass, forCellWithReuseIdentifier: NSStringFromClass(item.cellViewClass as! AnyClass))
            }
        }
    }
    
    func registerNib(for cellClass: AnyClass, collectionView: UICollectionView) {
        if !self.registeredClasses.filter({ $0 == cellClass }).isEmpty {
            return
        }
        
        let reuseIdentifier = NSStringFromClass(cellClass)
        guard let nibName = reuseIdentifier.components(separatedBy: ["."]).last else {
            return
        }
        let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.registeredClasses.append(cellClass)
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
        
        guard let dataSource = self.dataSource, let item = dataSource.item(from: indexPath) else {
            return UICollectionViewCell()
        }
        
        self.registerNib(for: item.cellViewClass as! AnyClass, collectionView: collectionView)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(item.cellViewClass as! AnyClass), for: indexPath) as? GBBaseCollectionViewCell {
            item.configure(cell)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource, let item = dataSource.item(from: indexPath) else {
            return
        }
        
        item.onDidSelect?(item)
    }
    
}

extension GBDynamicCollectionViewController: UICollectionViewDelegateFlowLayout {

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let dataSource = self.dataSource, let item = dataSource.item(from: indexPath) else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        
        return CGSize(width: collectionView.frame.width, height: item.cellHeight)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
