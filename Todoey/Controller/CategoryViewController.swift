//
//  CategoryViewController.swift
//  Todoey
//
//  Created by CR pradeep on 24/07/18.
//  Copyright © 2018 pradeep. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArray : [Category] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    //MARK:- loading items
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            print("error loading data, \(error)")
        }
        tableView.reloadData()
    }

    //MARK: ADD ITEM TO THE LIST
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextFeild = UITextField()
        
        let alert = UIAlertController(title: " Add new item to todo list", message: "Add now", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = newTextFeild.text!
          
            self.categoryArray.append(newCategory)
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
    
    //MARK: save stuff
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    //MARK:- Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsList", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray[indexPath.row]
        }
    }
    //MARK:- Data manipulation methods
    
   

   
    
    

}

