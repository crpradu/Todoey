//
//  ViewController.swift
//  Todoey
//
//  Created by CR pradeep on 11/07/18.
//  Copyright © 2018 pradeep. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    var itemArray : [Item] = []
    var selectedCategory :Category? {
        didSet {
           loadItems()
    }
    }

      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        }
    
    // MARK: Table View datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
         cell.accessoryType = item.isDone ? .checkmark : .none

        return cell
    }
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    //MARK: ADD ITEM TO THE LIST
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextFeild = UITextField()
        
        let alert = UIAlertController(title: " Add new item to todo list", message: "Add now", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
          
            
            let newItem = Item(context: self.context)
            newItem.title = newTextFeild.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            self.loadItems()
      
       }
        alert.addTextField(configurationHandler: { (textFeild) in
            textFeild.placeholder = "New to do item"
            newTextFeild = textFeild
            
            
        })
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
    }
    func loadItems(with predicate: NSPredicate? = nil , sortDescriptors: [NSSortDescriptor]? = nil) {
       let  request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@" , self.selectedCategory!.name!)
        if predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
        request.sortDescriptors = sortDescriptors
        do {
           itemArray =  try context.fetch(request)
        } catch {
            print("error loading data, \(error)")
        }
        tableView.reloadData()
        }
}
    //MARK: - Search bar methods
    extension TodoListViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           // let request: NSFetchRequest<Item> = Item.fetchRequest()
           let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
           let sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
           loadItems(with: predicate, sortDescriptors: sortDescriptors)
            
            
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


