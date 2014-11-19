//
//  NTTaskItem.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/19/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import Foundation

class NTTaskItem {
    var description: String?
    var completed: Bool?
    var creationDate: NSDate?
    var type: TaskType?
    
    init() {
        description = ""
        completed = false
        creationDate = NSDate()
        type = .Today
    }
    
    init(description: String?) {
        self.description = description
        completed = false
        creationDate = NSDate()
        type = .Today
    }
    
    class func createData() -> [NTTaskItem] {
        return [NTTaskItem(description: "Shopping for groceries"), NTTaskItem(description: "Play basketball with friends"), NTTaskItem(description: "Drink with David"), NTTaskItem(description: "Fix cellphone")]
    }
}

enum TaskType {
    case Today
    case Tomorrow
    case History
    case Deleted
}