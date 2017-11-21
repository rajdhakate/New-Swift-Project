//
//  ViewController.swift
//  New Swift Project
//
//  Created by Webdior Mac - 2 on 18/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let cellID = "Cell"
    var showIndexPath = false
    var showRows = false
    var showRowsBarButtonItem = UIBarButtonItem()
    var showSectionBarButtonItem = UIBarButtonItem()
    var refreshControlIndicator = UIRefreshControl()
    var names = [
    NamesStruct(name: ["Raj", "Ajay", "Preeti"], isExpanded: true),
    NamesStruct(name: ["Raj", "Ajay", "Preeti", "Maniraj"], isExpanded: true),
    NamesStruct(name: ["Raj", "Ajay", "Preeti", "Maniraj", "Silpa", "Sumant", "Anuva"], isExpanded: true),
    ]
    
    @objc func handleShowIndexPathButtonAction() {
        var indexPaths = [NSIndexPath]()
        for section in names.indices {
            for row in names[section].name.indices {
                let indexPath = NSIndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        }
        showIndexPath = !showIndexPath
        let style = showIndexPath ? UITableViewRowAnimation.right : .left
        tableView.reloadRows(at: indexPaths as [IndexPath], with: style)
    }
    
    @objc func handleRowButtonAction() {
        showRows = true
        reloadTableForRowsAndSections()
    }
    
    @objc func handleSectionButtonAction() {
        showRows = false
        reloadTableForRowsAndSections()
    }
    
    @objc func reloadTableForRowsAndSections() {
        if showRows {
            showSectionBarButtonItem.isEnabled = true
            showRowsBarButtonItem.isEnabled = false
        } else {
            showSectionBarButtonItem.isEnabled = false
            showRowsBarButtonItem.isEnabled = true
        }
        var indexPaths = [NSIndexPath]()
        for section in names.indices {
            for row in names[section].name.indices {
                let indexPath = NSIndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        }
        let style = showRows ? UITableViewRowAnimation.top : .bottom
        tableView.reloadRows(at: indexPaths as [IndexPath], with: style)
    }
    
    @objc func handleCloseShowAction(sender: UIButton) {
        var indexPaths = [IndexPath]()
        let section = sender.tag
        for row in names[section].name.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        names[section].isExpanded = !names[section].isExpanded
        if !names[section].isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPathButtonAction))
        showRowsBarButtonItem = UIBarButtonItem(title: "Rows", style: .plain, target: self, action: #selector(handleRowButtonAction))
        showSectionBarButtonItem = UIBarButtonItem(title: "Sections", style: .plain, target: self, action: #selector(handleSectionButtonAction))
        
        showSectionBarButtonItem.isEnabled = false
        showRowsBarButtonItem.isEnabled = true
        
        navigationItem.setLeftBarButtonItems([showRowsBarButtonItem, showSectionBarButtonItem], animated: true)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        refreshControlIndicator.addTarget(self, action: #selector(reloadTableForRowsAndSections), for: .valueChanged)
        tableView.addSubview(refreshControlIndicator)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.tag = section
        button.backgroundColor = .cyan
        button.titleLabel?.textColor = .black
        let title = names[section].isExpanded ? "Close" : "Open"
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(handleCloseShowAction), for: .touchUpInside)
        return button
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = showRows ? 0.0 : 45.0
        return CGFloat(height)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.zero)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if names[section].isExpanded {
            return names[section].name.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let name = names[indexPath.section].name[indexPath.row]
        cell.textLabel?.text = name
        
        if showIndexPath {
            cell.textLabel?.text = NSString(format: "%@\t\t\t\tSection: %d Row: %d", name, indexPath.row, indexPath.section) as String
        }
        
        refreshControlIndicator.endRefreshing()
        return cell
    }
}

