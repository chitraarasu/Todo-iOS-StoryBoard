//
//  CategoryViewControllerCollectionViewController.swift
//  Todo Swift UI
//
//  Created by kirshi on 1/1/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArrar = [CategoryData]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArrar[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = category.title
        
        cell.contentConfiguration = config
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationController = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destinationController.selectedCategory = categoryArrar[index.row]
        }
    }

    @IBAction func AddNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){ action in
            
            let data = CategoryData(context: self.context)
            
            data.title = textField.text
            
            self.categoryArrar.append(data)
            
            self.saveData()
        }
        
        alert.addTextField{ alertTextField in
            alertTextField.placeholder = "Create new category"
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
        self.tableView.reloadData();
    }
    
    func loadData(with request: NSFetchRequest<CategoryData> = CategoryData.fetchRequest()){
        do {
            categoryArrar = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
}
