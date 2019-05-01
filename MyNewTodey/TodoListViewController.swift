//
//  ViewController.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 30/4/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demonogormon"]
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let items  = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - TavbleView Delegate Methods
    
    // Will get fired when the cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
        print(itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at:indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at:indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at:indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   //Mark -- Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user Clicks the add item button on our UIALert
            
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray,forKey:"TodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            //print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert,animated: true, completion:nil)
    }
}
