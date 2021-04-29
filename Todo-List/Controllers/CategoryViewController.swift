//
//  CategoryViewController.swift
//  Todo-List
//
//  Created by youngjun kim on 2021/04/29.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {

    let realm = try! Realm()
    
    var category: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
//MARK: - Table view section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let selectedCategory = category?[indexPath.row] {
            if let backColor = UIColor(hexString: selectedCategory.color) {
                cell.textLabel?.text = selectedCategory.name
                cell.backgroundColor = backColor
                cell.textLabel?.textColor = ContrastColorOf(backColor, returnFlat: true)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
//MARK: Add button section
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(newCategory)
        }
        
        alert.addTextField { (myTextField) in
            textField = myTextField
            textField.placeholder = "New category"
        }
        
        alert.addAction(cancelAlert)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
        
//MARK: - Create section
    
    func save(_ category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            
        }
        tableView.reloadData()
    }
    
// MARK - Read section
    
    func load() {
        category = realm.objects(Category.self)
        tableView.reloadData()
    }
    
//MARK: - Swipe cell section
    
    override func deleteList(_ indexPath: IndexPath) {
        if let categoryToDelete = category?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(categoryToDelete)
                }
            } catch {
                print(error)
            }
        }
    }
}


