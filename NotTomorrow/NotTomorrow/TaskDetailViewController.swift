//
//  TaskDetailViewController.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/23/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var taskItem: NTTaskItem?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var markCompleted: UIButton!
    @IBOutlet weak var delete: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Task details"
        setupLabel()
        
    }
    
    func setupLabel() {
        let text = taskItem?.description
        if taskItem!.completed! {
            let fontSize = UIFont.labelFontSize()
            var attrs = [NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue, NSFontAttributeName: UIFont.italicSystemFontOfSize(fontSize)]
            descriptionLabel.attributedText = NSMutableAttributedString(string: text!, attributes: attrs)
        } else {
            var attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
            descriptionLabel.attributedText = NSMutableAttributedString(string: text!, attributes: attrs)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeClicked(sender: AnyObject) {
        taskItem?.completed = !taskItem!.completed!
        setupLabel()
    }
    
    @IBAction func deleteClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        let nav = UIApplication.sharedApplication().delegate?.window??.rootViewController as UINavigationController
        let tableViewController = nav.visibleViewController as TodayListController
        tableViewController.deleteTask(self.taskItem!.id!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
