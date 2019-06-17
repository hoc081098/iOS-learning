//
//  AddTodoViewController.swift
//  Todo
//
//  Created by Petrus on 6/13/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import UIKit
import RealmSwift

class AddOrUpdateViewController: UIViewController {
    
    @IBOutlet weak var stackCompleted: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var buttonAddOrUpdate: UIButton!
    @IBOutlet weak var switchCompleted: UISwitch!
    
    var todo: Todo? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            titleTextField.text = todo.title
            self.navigationItem.title = "Edit todo"
            self.buttonAddOrUpdate.setTitle("Update", for: .normal)
            self.switchCompleted.isOn = todo.completed
        } else {
            self.navigationItem.title = "Add new todo"
            
            self.buttonAddOrUpdate.setTitle("Add", for: .normal)
            self.buttonAddOrUpdate.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate(self.stackCompleted.constraints)
            NSLayoutConstraint.activate([
                self.buttonAddOrUpdate.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24)
                ])
            
            self.stackCompleted.isHidden = true
        }
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        guard let title = titleTextField.text else {
            return showToast(controller: self, message: "Required title", seconds: 1.5)
        }
        guard title.count >= 3 else {
            return showToast(controller: self, message: "Min length of title is  3", seconds: 1.5)
        }
        
        if let todo = self.todo{
            todo.update(title: title, completed: switchCompleted.isOn)
        } else {
            Todo.add(title: title)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

func showToast(controller: UIViewController, message : String, seconds: Double) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.black
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    
    controller.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        alert.dismiss(animated: true)
    }
}
