//
//  CategoryViewControllerCollectionViewController.swift
//  Todo Swift UI
//
//  Created by kirshi on 1/1/23.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    
    var categoryArrar: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrar?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArrar?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = category?.name
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destinationController.selectedCategory = categoryArrar?[index.row]
        }
    }

    @IBAction func AddNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){ action in
            
            let data = Category()
            
            data.name = textField.text!
            self.save(category: data)
            
        }
        
        alert.addTextField{ alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField;
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func save(category: Category){
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData();
    }
    
    func loadData(){
            categoryArrar = realm.objects(Category.self)
        self.tableView.reloadData();
    }
}
