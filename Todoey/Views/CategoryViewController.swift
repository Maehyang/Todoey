//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Maehyang Lee on 2018. 3. 6..
//  Copyright © 2018년 Maehyang Lee. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        

    }

    
    //MARK: - TableView Datasource Methods

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // If categories is not nil, then will return the number of categories we have. But if it's nil, then we're going to just return 1.
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let colorHexvalued = categories?[indexPath.row].color
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        guard let categoryColor = UIColor(hexString: colorHexvalued!) else {fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }

                tableView.reloadData()
            }
    }
    
    
    //MARK - Edit Data From Swipe
    
    override func editActionAlert(at indexPath: IndexPath) {
            var textTield = UITextField()
            let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Edit", style: .destructive) { (action) in
                if let categoryForEdit = self.categories?[indexPath.row] {
                    
                    do {
                        try self.realm.write {
                            categoryForEdit.name = textTield.text!
                        }
                    } catch {
                        print("Error editing name, \(error)")
                    }
                }
                
                self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.text = self.categories![indexPath.row].name
            textTield = alertTextfield
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
        
        
    }
        

    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        let alertCanceled = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Canceled")
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New category"
            textField = alertTextfield
        }
        
        alert.addAction(alertAction)
        alert.addAction(alertCanceled)
        
        present(alert, animated: true, completion: nil)
    }
}
