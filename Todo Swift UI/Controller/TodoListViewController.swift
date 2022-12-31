//
//  ViewController.swift
//  Todo Swift UI
//
//  Created by kirshi on 12/25/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArrar = [Item]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!);
        itemArrar.append(Item(title: "Buy Milk", done: false))
        itemArrar.append(Item(title: "Buy Bread", done: false))
        loadData()
//        if let data = defaults.array(forKey: "TodoItem") as? [String] {
//            itemArrar = data
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArrar[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = item.title
        
        cell.accessoryType = !itemArrar[indexPath.row].done ? .none : .checkmark
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArrar[indexPath.row].done = !itemArrar[indexPath.row].done
        self.saveData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ action in
            self.itemArrar.append(Item(title: textField.text!, done: false))
            
            //            self.defaults.set(self.itemArrar, forKey: "TodoItem")
            
            self.saveData()
        }
        
        alert.addTextField{ alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField;
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveData(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArrar)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error \(error)")
        }
        
        self.tableView.reloadData();
    }
    
    func loadData(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArrar = try decoder.decode([Item].self, from: data)
            } catch {
                print("ERROR \(error)")
            }
            
            
        }
        
        
    }
    
}

