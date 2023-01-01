//
//  ViewController.swift
//  Todo Swift UI
//
//  Created by kirshi on 12/25/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArrar = [Item]()
    
    var selectedCategory: CategoryData? {
        didSet {
            loadData()
        }
    }
//    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(dataFilePath!);
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
        
//        context.delete(itemArrar[indexPath.row])
//        itemArrar.remove(at: indexPath.row)
        
        itemArrar[indexPath.row].done = !itemArrar[indexPath.row].done
        self.saveData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ action in
            
            let data = Item(context: self.context)
            
            data.title = textField.text
            data.done = false
            data.parentCategory = self.selectedCategory
            self.itemArrar.append(data)
            
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
        
        do {
          try context.save()
        } catch {
            print(error)
        }
        
        
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArrar)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error \(error)")
//        }
//
        self.tableView.reloadData();
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        var categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedCategory!.title!)
        
        if predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArrar = try context.fetch(request)
        } catch {
            print(error)
        }
        
//        if let data = try? Data(contentsOf: dataFilePath!){
//
//            let decoder = PropertyListDecoder()
//
//            do {
//                itemArrar = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("ERROR \(error)")
//            }
//
//
//        }
        
        
    }
    
}


extension TodoListViewController: UISearchBarDelegate {
    
    func searchItems(text: String){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: NSPredicate(format: "title CONTAINS[cd] %@", text))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? false {
            loadData()
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
