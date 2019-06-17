//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by Petrus on 6/13/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var completedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(_ todo: Todo) {
        titleLabel?.text = todo.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm, dd/MM/yy"
        createdLabel?.text = "Created: \(dateFormatter.string(from: todo.created))"
        if todo.completed {
            completedImage.image = UIImage(named: "icon_checked")
            print(UIImage(named: "icon_checked"))
        } else {
            completedImage.image = nil
        }
    }
}
