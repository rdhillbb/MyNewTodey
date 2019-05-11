//
//  CaategoryViewController.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 4/5/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import UIKit
import RealmSwift


class CaategoryViewController: UITableViewController {
   
    let realm = try! Realm()
    
    var categoryArray:  Results<Category>?
    
    var textField = UITextField()
//    let defaults = UserDefaults.standard
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        //tableView.separatorStyle = .none
        
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            //newItem.done = false
            
            //self.categoryArray.append(newCategory)
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
            //print(alertTextField.text)
            
        }
        
        
        present(alert,animated: true, completion:nil)
    }
    
    //Mark: -- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        
       
        return cell
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //tableView.deselectRow(at: indexPath, animated: true)
        print("indexpath \(indexPath.row)")
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    //Mark: Data Manipulation Methods
    
    func save(category: Category) {
        //        let context = persistentContainer.viewContext
        
        do {
            try realm.write{
            realm.add(category)
            }
        } catch{
            print("error saving category,\(error)")
        }
        
        
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
        
    }
    
}
