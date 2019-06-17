//
//  ViewController.swift
//  Todo
//
//  Created by Petrus on 6/12/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import UIKit
import  RealmSwift


class MainViewController: UIViewController {
    
    @IBOutlet weak var todoTableView: UITableView!

    let items: Results<Todo> = Todo.allTodos()
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTableView.dataSource = self
        todoTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemsToken = items.observe { [weak todoTableView] changes in
            guard let tableView = todoTableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let updates):
                print("Changes \(changes)")
                tableView.applyChanges(
                    deletions: deletions,
                    insertions: insertions,
                    updates: updates
                )
                break
            case .error: break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        itemsToken?.invalidate()
    }
}


// MARK: - TableView Data Source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_cell", for: indexPath) as! TodoTableViewCell
        cell.bind(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

// MARK: - TableView Delegate
extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alertController = UIAlertController(title: "Delete item", message: "Are you sure you want to delete this todo?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.items[indexPath.row].delete()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addOrUpdateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddOrUpdateViewController") as! AddOrUpdateViewController
        addOrUpdateVC.todo = items[indexPath.row]
        self.navigationController?.pushViewController(addOrUpdateVC, animated: true)
    }
    
}


extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        performBatchUpdates({
            deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            reloadRows(at: updates.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        })
    }
}
