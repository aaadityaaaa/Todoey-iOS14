//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aaditya Singh on 06/09/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

import RealmSwift



class CategoryViewController: SwipeTableViewController {

    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        
        
    }
    
    
    //MARK:- table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return categories?.count ?? 1
       }
       
//       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//           cell.delegate = self
//           return cell
//       }
//
    
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
     
         return cell
    }
    
    //MARK:- table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        
       if let indexpath = tableView.indexPathForSelectedRow
       {
        destinationVC.selectedCategory = categories?[indexpath.row]
        }
        
    }
    
    
    
    
    
    //MARK:- data manipulation method
    
    func save(category: Category) {
        
        do {
            try realm.write{
                realm.add(category)
                }
    }
        catch {
            print("error saving category")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
       categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK:- deletesection
    
    override func updateModel(at indexpath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexpath.row] {
                 do {
                   try self.realm.write {
                                   self.realm.delete(categoryForDeletion)
                                     }
                                     }catch {
                                         print("error")
                                     }
                           tableView.reloadData()
                       }
    }
    
    
    
    
    //MARK:- addbuttonItem
      
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        

                var textfield = UITextField()
                
                let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Add", style: .default) { (action) in
                           //what will happen once the user clicks the add item button on ui alert
            
                    let newCategory = Category()
                    
                    newCategory.name = textfield.text!
                    
                    self.save(category: newCategory)
                    
                }
                
            
                alert.addAction(action)
                alert.addTextField { (field) in
                    textfield = field
                    textfield.placeholder = "add a new category"
                }
            present(alert, animated: true, completion: nil)
            
        }
        
        
    }
//MARK:- swipecell delegate methods


