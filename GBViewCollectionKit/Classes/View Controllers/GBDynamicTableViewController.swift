//
//  GBDynamicTablewViewController.swift
//  GBViewCollectionKit
//
//  Created by Gennadii Berezovskii on 07.10.19.
//

import UIKit

open class GBDynamicTableViewController: UITableViewController {
    
    var registeredClasses = [AnyClass]()
    
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    open var dataSource: GBViewCollectionDataSource? {
        didSet {
            dataSource?.contentView = tableView
            
            setupCommands()
            
            self.tableView.reloadData()
        }
    }
    
    func setupCommands() {
        dataSource?.onScrollToIndexPath = { [weak self] (indexPath) in
            self?.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
        
        dataSource?.onGetIndexPathAtPoint = { [weak self] (point) in
            return self?.tableView?.indexPathForRow(at: point)
        }
        
        dataSource?.onInsertCellView = { [weak self] (item, completion) in
            guard let indexPath = self?.dataSource?.indexPath(ofItem: item) else {
                return
            }
            
            self?.tableView?.insertRows(at: [indexPath], with: .automatic)
        }
        
        dataSource?.onInsertSectionView = { [weak self] (section, completion) in
            guard let index = self?.dataSource?.sections.index(where: { $0 === section }) else {
                return
            }
            
            self?.tableView?.insertSections(IndexSet(integer: index), with: .automatic)
        }
        
        dataSource?.onDeleteCellView = { [weak self] (item, completion) in
            guard let indexPath = self?.dataSource?.indexPath(ofItem: item) else {
                assertionFailure("Cell model object not found anywhere in items array")
                return
            }
            
            item.section?.remove(item)
            self?.tableView?.deleteRows(at: [indexPath], with: .automatic)
        }
        
        dataSource?.onDeleteSectionView = { [weak self] (section, completion) in
            guard let index = self?.dataSource?.sections.index(where: { $0 === section }) else {
                return
            }
            
            self?.tableView?.deleteSections(IndexSet(integer: index), with: .automatic)
        }
        
        dataSource?.onReloadContentView = { [weak self] in
            self?.tableView.reloadData()
        }
        
        dataSource?.onReloadItems = { [weak self] (indexPaths) in
            self?.tableView.reloadRows(at: indexPaths, with: .automatic)
        }
        
        dataSource?.onReloadSection = { [weak self] (index) in
            self?.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
        }
        
        dataSource?.onGetCell = { [weak self] (indexPath) in
            return self?.tableView?.cellForRow(at: indexPath) as? GBCollectionViewCell
        }
    }
}

extension GBDynamicTableViewController {
    
    func registerNib(forCellClass cellClass: AnyClass, tableView: UITableView) {
        if self.registeredClasses.contains(where: { $0 == cellClass }) {
            return
        }
        
        let reuseIdentifier = String(describing: cellClass)
        let nib = UINib.init(nibName: reuseIdentifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        self.registeredClasses.append(cellClass)
    }
    
    func registerNib(forHeaderFooterViewClass viewClass: AnyClass, tableView: UITableView) {
        if self.registeredClasses.contains(where: { $0 == viewClass }) {
            return
        }
        
        let reuseIdentifier = String(describing: viewClass)
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: viewClass))
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        self.registeredClasses.append(viewClass)
    }
    
}

extension GBDynamicTableViewController {
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.sections.count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        let section = dataSource.sections[section]
        return section.items.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = self.dataSource, let item = dataSource.itemFrom(indexPath) else {
            return UITableViewCell()
        }
        
        self.registerNib(forCellClass: item.cellViewClass as AnyClass, tableView: tableView)
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: item.cellViewClass), for: indexPath) as? GBBaseTableViewCell {
            item.configure(cell)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource, let item = dataSource.itemFrom(indexPath) else {
            return
        }
        
        item.onDidSelect?(item)
    }
    
    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = heightDictionary[indexPath.row] else {
            return UITableView.automaticDimension
        }
        return height
    }
}
