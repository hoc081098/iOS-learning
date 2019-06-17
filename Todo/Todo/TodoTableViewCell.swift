//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by Petrus on 6/13/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    private var item: Todo?
    private var onToggle: ((Todo) -> Void)?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var completedImage: UIButton!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm, dd/MM/yy"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func toogleClick(_ sender: Any) {
        guard let item = self.item else { return }
        onToggle?(item)
        print("Toogle")
    }
    
    func bind(_ todo: Todo, onToggle: ((Todo) -> Void)? = nil) {
        self.item = todo
        self.onToggle = onToggle
        
        titleLabel?.text = todo.title
        createdLabel?.text = "Created: \(dateFormatter.string(from: todo.created))"
        completedImage.setImage(
            UIImage(named: todo.completed ? "ic_checked" : "ic_unchecked"),
            for: .normal
        )
    }
}
