//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Jahic on 13.02.19.
//  Copyright © 2019 Denis Jahic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class todoListViewController: SwipeTableTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        //posto je selectedCategory nil dok se ne klikne na celiju, zato stavljam kao optional...... a didSet radi samo i iskljucivo nakon sto sam kliknuo na celiju
        didSet {
           loadItems()
        }
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.colour else {
            fatalError()
        }
        
        updateNavbar(withHexCode: colourHex)
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavbar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar setup methods
    func updateNavbar(withHexCode colourHexCode : String) {
        guard let navBar = navigationController?.navigationBar
            else {
                fatalError("navigation controller does not exist")
        }
        guard let navBarColour = UIColor(hexString: colourHexCode)
            else {
                fatalError()
        }
        //background of the navigation bar
        navBar.barTintColor = navBarColour
        //addButton and Todoey text colour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
        
    }
    
    //MARK - Tableview Datasource Methods
    //                 NUMBERofRows
    //              CellForRowAt
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                
                cell.backgroundColor = colour
                
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            //Ternary operator ==>
            //  value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
           
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // UPDATE using realm
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
            }
            catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        //button to press when I am done with writing my todo list item
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks the Add Item button on my UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                        newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                }
                    catch {
                        print("Error saving new items, \(error)")
                    }
                }
            
            self.tableView.reloadData()
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
             //kreiranje bijelog polja gdje kucam new item
            textField = alertTextField
        }
        alert.addAction(action) //startovanje alerta koji sam gore kodirao
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
//    func saveItems () {
//
//        do {
//            try context.save()
//        }
//        catch {
//            print("Error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//
//        //it is not working as it should if I do not have .reloadData() in my code, add it every time if I want to see new stuff added to my itemArray
//        }
    
    
    // external parameter..with, internal param..reques,
    //default value..= Item.fetchRequest()
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)



        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                        realm.delete(item)
                }
            }
            catch {
                print("error deleting item \(error)")
            }
            
        }
    }
   

}
//MARK: - Search bar methods

extension todoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    //after searching is done, method for going back to whole list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }

        }
    }

}

