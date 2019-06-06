//
//  MonthSection.swift
//  Learning
//
//  Created by Petrus on 6/6/19.
//  Copyright © 2019 Petrus. All rights reserved.
//

import Foundation

struct MonthSection : Comparable{
    static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month < rhs.month
    }
    
    static func == (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month == rhs.month
    }
    
    let month: Date
    let headlines: [Headline]
}
