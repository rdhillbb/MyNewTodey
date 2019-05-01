//
//  ViewController.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 30/4/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendPathComponent("Items.plist")
//        print(dataFilePath)
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        let newItem2 = Item()
//        newItem2.title = "Bug Eggs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        
        loadItems()
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark:.none
        return cell
    }
    
    //MARK - TavbleView Delegate Methods
    
    // Will get fired when the cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
//        tableView.reloadData()

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   //Mark -- Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user Clicks the add item button on our UIALert
            let newItem = Item()
            newItem.title = textField.text!

            self.itemArray.append(newItem)
            self.saveItems()
            
////            self.defaults.set(self.itemArray,forKey:"TodoListArray")
//            let encoder = PropertyListEncoder()
//            do {
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            } catch{
//
//            }
            
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
    
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            tableView.reloadData()
        } catch{
            print("error endocing item array,\(error)")
        }
        
        
    }
    
    func loadItems() {
       
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                   itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error Cannot Readfile \(error)")
            }
            
        }
    }
}

