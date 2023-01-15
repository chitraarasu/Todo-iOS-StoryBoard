//
//  ViewController.swift
//  Todo Swift UI
//
//  Created by kirshi on 12/25/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    
    var selectedCategory: Category?
    
    var todoItem: Results<Items>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = todoItem?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = item?.title
        
        cell.accessoryType = !(todoItem?[indexPath.row].done ?? false) ? .none : .checkmark
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItem?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ action in
            
            if self.todoItem != nil {
                do {
                    try self.realm.write{
                        let data = Items()
                        data.title = textField.text ?? ""
                        self.realm.add(data)
                        self.selectedCategory?.items.append(data)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField{ alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField;
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}




extension TodoListViewController: UISearchBarDelegate {
    
    func searchItems(text: String){
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? false {
            loadItems()
        } else {
            searchItems(text: searchBar.text!)
        }
        
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems(text: searchBar.text!)
        tableView.reloadData()
    }
}
