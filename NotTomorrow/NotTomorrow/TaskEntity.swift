//
//  TaskEntity.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 12/3/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import Foundation
import CoreData

class TaskEntity: NSManagedObject {

    @NSManaged var taskDescription: String
    @NSManaged var creationDate: NSDate
    @NSManaged var completed: NSNumber
    @NSManaged var type: NSNumber
    @NSManaged var estimated: NSNumber
    @NSManaged var consumed: NSNumber
    @NSManaged var startTime: NSDate
    
    var isCompleted: Bool {
        get {
            return self.completed == true
        }
        set(completed) {
            self.completed = completed
        }
    }

    class func entityName() -> String {
        return "TaskEntity"
    }
    
    class func forgeItem(moc: NSManagedObjectContext, title: String) -> TaskEntity {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(TaskEntity.entityName(), inManagedObjectContext: moc) as TaskEntity
        newItem.taskDescription = title
        newItem.completed = false
        newItem.creationDate = NSDate()
        newItem.estimated = 0
        newItem.consumed = 0
        newItem.type = 1
        
        var error: NSError?
        moc.save(&error)
        
        return newItem
    }
}
