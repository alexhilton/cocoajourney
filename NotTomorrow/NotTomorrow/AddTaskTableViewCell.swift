//
//  AddTaskTableViewCell.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/20/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit

class AddTaskTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var addTaskBox: UITextField!
    var addingNewTask: Bool? {
        didSet {
            NSLog("after set value to addingNewTask %@", addingNewTask!)
            imageView!.hidden = !addingNewTask!
            addTaskBox!.hidden = !addingNewTask!
            if addingNewTask! {
                imageView!.image = UIImage(named: "ic_unchcked_normal.png")
                addTaskBox!.becomeFirstResponder()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView!.hidden = true
        addingNewTask = false
        addTaskBox!.hidden = true
        addTaskBox!.delegate = self
        addTaskBox!.backgroundColor = UIColor.darkGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        NSLog("add task box is selected %@, animated %@", selected, animated)
        // Configure the view for the selected state
    }
    
    @IBAction func taskAdded(sender: AnyObject) {
        NSLog("stuff task '%@'", addTaskBox!.text)
        let nav = UIApplication.sharedApplication().delegate?.window??.rootViewController as UINavigationController
        let tableViewController = nav.visibleViewController as TodayListController
        tableViewController.addTask(self.addTaskBox!.text)
        tableViewController.tableView.reloadData()
        addTaskBox!.resignFirstResponder()
        addingNewTask = false
    }
}