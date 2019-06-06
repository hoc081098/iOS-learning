//
//  StoriesTableViewController.swift
//  Learning
//
//  Created by Petrus on 6/6/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {
    @IBOutlet weak var headLineTitleLabel: UILabel!
    @IBOutlet weak var headLineTextLabel: UILabel!
    @IBOutlet weak var headLineDateLabel: UILabel!
    @IBOutlet weak var headLineImageView: UIImageView!
    
    fileprivate func bind(_ headline: Headline) {
        headLineTitleLabel.text = headline.title
        headLineTextLabel.text = headline.text
        headLineImageView.image = UIImage(named: headline.image)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        headLineDateLabel.text = dateFormatter.string(from: headline.date)
    }
}

fileprivate func firstDayOrMonth(date: Date) -> Date {
    let current: Calendar = Calendar.current
    let components: DateComponents = current.dateComponents([.month, .year], from: date)
    return current.date(from: components)!
}

fileprivate func parseDate(_ date: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter.date(from: date)!
}

class StoriesTableViewController: UITableViewController {
    static let headlines: [Headline] = [
        Headline(
            id: 1,
            title: "Title 1",
            text:"Text 1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl suscipit adipiscing bibendum est. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi",
            image: "Banana",
            date: parseDate("02-02-2019")
        ),
        Headline(
            id: 2,
            title: "Title 2",
            text:"Text 2 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl suscipit adipiscing bibendum est. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi",
            image: "Apple",
            date: parseDate("02-03-2019")
        ),
        Headline(
            id: 3,
            title: "Title 3",
            text:"Text 3 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl suscipit adipiscing bibendum est. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi",
            image: "Cantaloupe",
            date: parseDate("03-02-2019")
        ),
        Headline(
            id: 4,
            title: "Title 4",
            text:"Text 4 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl suscipit adipiscing bibendum est. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi",
            image: "Apricot",
            date: parseDate("02-05-2019")
        ),
        Headline(
            id: 5,
            title: "Title 5",
            text:"Text 5 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl suscipit adipiscing bibendum est. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi",
            image: "Blueberry",
            date: parseDate("19-03-2019")
        ),
        Headline(
            id: 6,
            title: "Title 6",
            text:"Text 6 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl suscipit adipiscing bibendum est. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi",
            image: "Cantaloupe",
            date: parseDate("20-03-2019")
        )
    ]
    let sections = Dictionary(grouping: headlines, by:  { headline in
        return firstDayOrMonth(date: headline.date)
    }).map(MonthSection.init(month:headlines:)).sorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: section.month)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            as! HeadlineTableViewCell
        
        cell.bind(sections[indexPath.section].headlines[indexPath.row])
        
        return cell
    }
    
}
