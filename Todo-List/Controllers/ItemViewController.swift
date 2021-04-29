//
//  ItemViewController.swift
//  Todo-List
//
//  Created by youngjun kim on 2021/04/29.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemViewController: SwipeViewController {

    let realm = try! Realm()
    
    var itemList: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
//MARK: - Navigationbar section
    
    override func viewWillAppear(_ animated: Bool) {
        if let hexColor = selectedCategory?.color {
            title = selectedCategory!.name
            if let navigation = navigationController?.navigationBar {
                if let uiColor = UIColor(hexString: hexColor) {
                    navigation.backgroundColor = uiColor
                    navigation.tintColor = ContrastColorOf(uiColor, returnFlat: true)
                    searchBar.backgroundColor = uiColor
                }
            }
        }
    }
    
    
//MARK: - TableView section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let itemRow = selectedCategory?.items[indexPath.row] {
            cell.textLabel?.text = itemRow.title
            cell.accessoryType = itemRow.done ? .checkmark: .none
            if let hexColor = selectedCategory?.color {
                cell.backgroundColor = UIColor(hexString: hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(selectedCategory!.items.count))
                if let backColor = cell.backgroundColor {
                    cell.textLabel?.textColor = ContrastColorOf(backColor, returnFlat: true)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let flag = itemList?[indexPath.row] {
            do {
                try realm.write{
                    flag.done = !flag.done
                }
            } catch {
                print(error)
            }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
//MARK: Add button section
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add todo list", message: "", preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            newItem.time = Date()
            
            do {
                try self.realm.write{
                    self.selectedCategory?.items.append(newItem)
                }
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (myTextField) in
            textField = myTextField
            textField.placeholder = "New todo list"
        }
        
        alert.addAction(cancelAlert)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Read section
    
    func load() {
        itemList = selectedCategory?.items.sorted(byKeyPath: "time", ascending: true)
        tableView.reloadData()
    }
    
//MARK: - Swipe cell section
    
    override func deleteList(_ indexPath: IndexPath) {
        if let itemToDelete = itemList?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(itemToDelete)
                }
            } catch {
                print(error)
            }
        }
    }
}

//MARK: - Search bar section

extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            load()
            searchBar.resignFirstResponder()
        }
    }
}
