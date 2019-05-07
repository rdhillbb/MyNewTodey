//
//  CaategoryViewController.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 4/5/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import UIKit
import CoreData


class CaategoryViewController: UITableViewController {
   
    var categoryArray = [Category]()
    var textField = UITextField()
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

        
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user Clicks the add item button on our UIALert
            
            //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newCategory = Category(context:self.context)
            newCategory.name = textField.text!
            //newItem.done = false
            
            self.categoryArray.append(newCategory)
            self.saveCategory()
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
       
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
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //Mark: Data Manipulation Methods
    
    func saveCategory() {
        //        let context = persistentContainer.viewContext
        
        do {
            try context.save()
            self.tableView.reloadData()
        } catch{
            print("error saving category,\(error)")
        }
        
        
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            categoryArray = try  context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        tableView.reloadData()
        
    }
    
}
