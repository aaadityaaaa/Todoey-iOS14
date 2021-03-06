//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

     
    var itemArray: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        
        didSet{
           loadItems()
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
    
      
    }

    
    //MARK:- table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.title
          cell.accessoryType = item.done ? .checkmark : .none
                  
        }else {
            cell.textLabel?.text = "No Items Added"
        }
    
        return cell
        
        
    }
    
    
    //MARK:- table view delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = itemArray?[indexPath.row] {
            do {
            try realm.write {
                
                item.done = !item.done
            }
            }catch {
                print("error")
            }
        }
        tableView.reloadData()

        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//MARK:- addbuttonItem
    
    
    @IBAction func addButtonItem(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
   
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on ui alert
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                              let newItem = Item()
                               newItem.title = textField.text!
                               newItem.dateCreated = Date()
                               currentCategory.items.append(newItem)
                              
                          }
                }catch {
                    print("error")
                    
                }
            }

            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
           textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK:- model manipulation method
    
 
    
    
    func loadItems() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

    override func updateModel(at indexpath: IndexPath) {
        if let item = itemArray?[indexpath.row]{
            do {
                try realm.write {
                               realm.delete(item)
                           }
            }catch {
                print("error")
            }
          
        }
    }
    
}


extension ToDoListViewController: UISearchBarDelegate {
      
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "title", ascending: true)
    
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
  
