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
    var id: Int?
    var startTime: NSDate?
    
    var estimated: Int? {
        didSet {
            if estimated > 6 {
                estimated = 6
            }
        }
    }
    
    var consumed: Int?
    
    init(id: Int) {
        description = ""
        completed = false
        creationDate = NSDate()
        type = .Today
        self.id = id
        estimated = 0
        consumed = 0
    }
    
    init(description: String?, id: Int) {
        self.description = description
        completed = false
        creationDate = NSDate()
        type = .Today
        self.id = id
        estimated = 0
        consumed = 0
    }
    
    class func createData() -> [NTTaskItem] {
        return [NTTaskItem(description: "Shopping for groceries", id: 0), NTTaskItem(description: "Play basketball with friends", id: 1), NTTaskItem(description: "Drink with David", id: 2), NTTaskItem(description: "Fix cellphone", id: 3), NTTaskItem(id: -1)]
    }
}

enum TaskType {
    case Today
    case Tomorrow
    case History
    case Deleted
}