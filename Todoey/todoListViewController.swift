//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Jahic on 13.02.19.
//  Copyright © 2019 Denis Jahic. All rights reserved.
//

import UIKit

class todoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike" , "Buy Eggos", "Destroy Demegorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - Tableview Datasource Methods
    //                 NUMBERofRows
    //              CellForRowAt
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
            //provjera koji red je oznacen i radi dalje sta se reklo u funkciji da se mora raditi
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        //button to press when I am done with writing my todo list item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks the Add Item button on my UIAlert
            self.itemArray.append(textField.text!)
            self.tableView.reloadData() //it is not working as it should if I do not have .reloadData() in my code, add it every time if I want to see new stuff added to my itemArray
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print(alertTextField.text!) //kreiranje bijelog polja gdje kucam new item
            textField = alertTextField
        }
        alert.addAction(action) //startovanje alerta koji sam gore kodirao
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

