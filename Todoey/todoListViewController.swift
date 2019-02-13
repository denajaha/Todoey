//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Jahic on 13.02.19.
//  Copyright © 2019 Denis Jahic. All rights reserved.
//

import UIKit

class todoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike" , "Buy Eggos", "Destroy Demegorgon"]

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
    
    
}

