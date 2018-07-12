//
//  ViewController.swift
//  Todoey
//
//  Created by CR pradeep on 11/07/18.
//  Copyright © 2018 pradeep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray : [String] = []
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items =  defaults.array(forKey: "toDoListArray") as? [String] {
            itemArray = items }
    }
    // MARK: Table View datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none       }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: ADD ITEM TO THE LIST
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextFeild = UITextField()
        
        let alert = UIAlertController(title: " Add new item to todo list", message: "Add now", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textFeild) in
            textFeild.placeholder = "New to do item"
            newTextFeild = textFeild
           
            
        })
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
          
            self.itemArray.append(newTextFeild.text!)
            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            self.tableView.reloadData()
      
       }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
}

