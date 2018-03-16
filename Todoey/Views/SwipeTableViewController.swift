//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Maehyang Lee on 2018. 3. 9..
//  Copyright © 2018년 Maehyang Lee. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
    
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editActionAlert(at: indexPath)
        }
        
        
    // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction, editAction]
    }
    
    //Edit Action Alert model
    
    func editActionAlert(at indexPath: IndexPath) {
        
}

    func updateModel(at indexPath: IndexPath) {
        // Update our data model
    }
    
}

