//
//  ViewController.swift
//  MyNewTodey
//
//  Created by Randolph Davis Hill on 30/4/19.
//  Copyright © 2019 Randolph Davis Hill. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
         loadItems()
        }
    }
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title
        
        if  let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark:.none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - TavbleView Delegate Methods
    
    // Will get fired when the cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
               try realm.write {
                   item.done = !item.done
            }
            } catch  {
                  print("Error Save done status \(error)")
            }
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //Mark: -- Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user Clicks the add item button on our UIALert
            
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error same new items, \(error)")
                }
            
            }
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
    
    
    //MARK: - Model Manipulation Methods
    
    func saveItems(item: Item) {
//        let context = persistentContainer.viewContext
//
//        do {
//            try context.save()
//            self.tableView.reloadData()
//        } catch{
//            print("error endocing item array,\(error)")
//        }
        do {
            try realm.write{
                realm.add(item)
            }
        } catch{
            print("error saving category,\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems (){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    
    }
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//       // let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//
//      do {
//       itemArray = try  context.fetch(request)
//    } catch {
//            print("Error fetching data from context\(error)")
//       }
//         tableView.reloadData()
//
//    }
    
    
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
    
}

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
          loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

}
