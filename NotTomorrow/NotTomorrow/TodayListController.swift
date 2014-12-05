//
//  TodayListController.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/18/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit
import CoreData

class TodayListController: UITableViewController {
    
    var taskList = [TaskEntity]()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let moc = appDelegate.managedObjectContext {
            return moc
        } else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let formater = NSDateFormatter()
        formater.dateFormat = "EEE MMM-dd"
        let today = formater.stringFromDate(NSDate())
        title = "Today -- \(today)"

        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "triggerAdd")
        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView!.registerNib(UINib(nibName: "AddTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "addcell")
        
        loadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataChanged:", name: NSManagedObjectContextDidSaveNotification, object: managedObjectContext)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView?.reloadData()
    }

    private func forgeData() {
        // Testing the core data here
        TaskEntity.forgeItem(self.managedObjectContext!, title: "Shopping for groceries")
        TaskEntity.forgeItem(self.managedObjectContext!, title: "Play pingpong with David")
        TaskEntity.forgeItem(self.managedObjectContext!, title: "Download a game from app store")
        TaskEntity.forgeItem(self.managedObjectContext!, title: "Call mom to confirm the weekend party")
        TaskEntity.forgeItem(self.managedObjectContext!, title: "Send email to Luke to ask the pictures")
    }
    
    private func loadData() {
        let fetchRequest = NSFetchRequest(entityName: TaskEntity.entityName())
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let frs = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [TaskEntity] {
            taskList = frs
        }
        if taskList.count == 0 {
            forgeData()
            loadData()
        }
    }
    
    func triggerAdd() {
        let indexPath = NSIndexPath(forRow: taskList.count - 1, inSection: 0)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as AddTaskTableViewCell
        if cell.addingNewTask! {
            // ignore the event if we are already in adding mode
            return
        }
        cell.addingNewTask = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return taskList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == taskList.count - 1 {
            let acell = tableView.dequeueReusableCellWithIdentifier("addcell", forIndexPath: indexPath) as AddTaskTableViewCell
//            acell.selectionStyle = UITableViewCellSelectionStyle.None
            return acell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        let text = taskList[indexPath.row].taskDescription
        if taskList[indexPath.row].isCompleted {
            let fontSize = UIFont.labelFontSize()
            var attrs = [NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue, NSFontAttributeName: UIFont.italicSystemFontOfSize(fontSize)]
            cell.textLabel!.attributedText = NSMutableAttributedString(string: text, attributes: attrs)
        } else {
            var attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
            cell.textLabel!.attributedText = NSMutableAttributedString(string: text, attributes: attrs)
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        let completed = taskList[indexPath.row].isCompleted
        cell.imageView!.image = UIImage(named: (completed ? "ic_checked_normal.png" : "ic_unchcked_normal.png"))
        cell.imageView!.userInteractionEnabled = false
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.row == taskList.count - 1 {
            return false
        }
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext?.deleteObject(taskList[indexPath.row])
            taskList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let tmp = taskList[fromIndexPath.row].creationDate
        taskList[fromIndexPath.row].creationDate = taskList[toIndexPath.row].creationDate
        taskList[toIndexPath.row].creationDate = tmp;
        
        var error: NSError?
        managedObjectContext?.save(&error)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.row == taskList.count - 1 {
            return false
        }
        return true
    }
    
    // MARK: - Delegation
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.row == taskList.count - 1 {
            return
        }
        viewTaskDetail(index: indexPath.row)
    }
    
    private func viewTaskDetail(#index: Int?) {
        let viewController = TaskDetailViewController(nibName: "TaskDetailViewController", bundle: nil)
        viewController.taskItem = self.taskList[index!]
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == taskList.count - 1 {
            var cell = tableView.cellForRowAtIndexPath(indexPath) as AddTaskTableViewCell
            if cell.addingNewTask! {
                // ignore the event if we are already in adding mode
                return
            }
            cell.addingNewTask = true
            return
        }
        taskList[indexPath.row].isCompleted = !taskList[indexPath.row].isCompleted
        tableView.reloadData()
    }
    
    // MARK: - Notifications
    func dataChanged(notification: NSNotification) {
        loadData()
        tableView?.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
