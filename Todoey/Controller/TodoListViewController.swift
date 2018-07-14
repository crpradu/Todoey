//
//  ViewController.swift
//  Todoey
//
//  Created by CR pradeep on 11/07/18.
//  Copyright © 2018 pradeep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray : [Item] = []
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let test1 = Item()
        test1.title = "item1"
        test1.isDone = true
        itemArray.append(test1)
        let test2 = Item()
        test2.title = "item2"
        test2.isDone = false
        itemArray.append(test2)
        let test3 = Item()
        test3.title = "item3"
        test3.isDone = false
        itemArray.append(test3)
        
        if let items =  defaults.array(forKey: "toDoListArray") as? [Item] {
            itemArray = items }

        
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
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    //MARK: ADD ITEM TO THE LIST
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextFeild = UITextField()
        
        let alert = UIAlertController(title: " Add new item to todo list", message: "Add now", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = newTextFeild.text!
            self.itemArray.append(newItem)
           //self.defaults.set(self.itemArray , forKey: "toDoListArray")
            self.tableView.reloadData()
      
       }
        alert.addTextField(configurationHandler: { (textFeild) in
            textFeild.placeholder = "New to do item"
            newTextFeild = textFeild
            
            
        })
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
}

