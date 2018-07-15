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

    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
                
        loadItems()
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
            let newItem = Item()
            newItem.title = newTextFeild.text!
            self.itemArray.append(newItem)
            self.saveItems()
      
       }
        alert.addTextField(configurationHandler: { (textFeild) in
            textFeild.placeholder = "New to do item"
            newTextFeild = textFeild
            
            
        })
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilepath)
            self.tableView.reloadData()
        } catch {
            print("error encoding itemArray, \(error)")
        }
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilepath) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch { print("error decodeing , \(error)") }
        }
        
        
    }
    
}

