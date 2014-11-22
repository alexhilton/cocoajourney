//
//  TodayListController.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/18/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit

class TodayListController: UITableViewController {
    var tasks: [NTTaskItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let formater = NSDateFormatter()
        formater.dateFormat = "EEE MMM-dd"
        let today = formater.stringFromDate(NSDate())
        title = "Today -- \(today)"
        tasks = NTTaskItem.createData()
        navigationItem.rightBarButtonItem = editButtonItem()
        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView!.registerNib(UINib(nibName: "AddTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "addcell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Public interface
    func addTask(description: String) {
        let item = NTTaskItem(description: description)
        let last = tasks!.count - 1
        tasks!.insert(item, atIndex: last)
        tableView?.reloadData()
        NSLog("add task are you aware %@, count %d", description, tasks!.count)
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
        return tasks!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == tasks!.count - 1 {
            let acell = tableView.dequeueReusableCellWithIdentifier("addcell", forIndexPath: indexPath) as AddTaskTableViewCell
//            acell.selectionStyle = UITableViewCellSelectionStyle.None
            return acell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        cell.textLabel.text = tasks![indexPath.row].description
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        let completed = tasks![indexPath.row].completed
        cell.imageView.image = UIImage(named: (completed! ? "ic_checked_normal.png" : "ic_unchcked_normal.png"))
        let singleTap = UITapGestureRecognizer()
        singleTap.addTarget(self, action: "thumbTapped:")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        cell.imageView.addGestureRecognizer(singleTap)
        cell.imageView.userInteractionEnabled = true
        return cell
    }
    
    func thumbTapped(gestureRecognizr: UITapGestureRecognizer) {
        NSLog("thumbnail clicked")
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.row == tasks!.count - 1 {
            return false
        }
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tasks!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let tmp = tasks![fromIndexPath.row]
        tasks![fromIndexPath.row] = tasks![toIndexPath.row]
        tasks![toIndexPath.row] = tmp;
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.row == tasks!.count - 1 {
            return false
        }
        return true
    }
    
    // MARK: - Delegation
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tasks!.count - 1 {
            return
        }
        viewTaskDetail(index: indexPath.row)
    }
    
    private func viewTaskDetail(#index: Int?) {
        let alert = UIAlertView()
        alert.title = "Notification"
        alert.message = "View the details about this task, will comming soon."
        alert.addButtonWithTitle("Okay")
        alert.show()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tasks!.count - 1 {
            var cell = tableView.cellForRowAtIndexPath(indexPath) as AddTaskTableViewCell
            if cell.addingNewTask! {
                // ignore the event if we are already in adding mode
                return
            }
            cell.addingNewTask = true
            return
        }
        tasks![indexPath.row].completed = !tasks![indexPath.row].completed!
        tableView.reloadData()
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
