//
//  TaskDetailViewController.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/23/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var taskItem: TaskEntity?
    
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var estimatedPomodoros: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var markCompleted: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var labelPlan: UILabel!
    @IBOutlet weak var planTimePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Task details"
        
        // setup the estimated pomodoro indicators.
        estimatedPomodoros.backgroundColor = UIColor.whiteColor()
        estimatedPomodoros.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        estimatedPomodoros.delegate = self
        estimatedPomodoros.dataSource = self
        
        // set up the plan time label
        labelPlan.userInteractionEnabled = true
        // It also works, if we remove 'Selector(...)'
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("labelPlanTapped:"))
        labelPlan.addGestureRecognizer(tapGesture)
        
        // setup the time picker
        planTimePicker.hidden = true
        // Have to set the background with code. It does not work with XIB or storyboard.
        planTimePicker.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        planTimePicker.minimumDate = NSDate()
        
        refreshControls()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshControls()
    }
    
    func labelPlanTapped(sender: UITapGestureRecognizer) {
        if taskItem!.isCompleted {
            let alert = UIAlertView()
            alert.title = "Notification"
            alert.message = "The task is already completed. You do not need to plan it anymore. ^_^"
            alert.addButtonWithTitle("Okay")
            alert.show()
            return
        }
        planTimePicker.date = taskItem!.startTime
        
        planTimePicker.hidden = !planTimePicker.hidden
    }
    
    func refreshControls() {
        let text = taskItem!.taskDescription
        buttonStart.enabled = !taskItem!.isCompleted
        if taskItem!.isCompleted {
            let fontSize = UIFont.labelFontSize()
            var attrs = [NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleThick.rawValue, NSFontAttributeName: UIFont.italicSystemFontOfSize(fontSize)]
            descriptionLabel.attributedText = NSMutableAttributedString(string: text, attributes: attrs)
            markCompleted.setTitle("Mark as Incomplete", forState: UIControlState.Normal)
        } else {
            var attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
            descriptionLabel.attributedText = NSMutableAttributedString(string: text, attributes: attrs)
            markCompleted.setTitle("Mark complete", forState: UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeClicked(sender: AnyObject) {
        taskItem!.isCompleted = !taskItem!.isCompleted
        refreshControls()
    }
    
    @IBAction func startClicked(sender: AnyObject) {
        // start a pomodoro
        var pomodoro = PomodoroViewController(nibName: "PomodoroViewController", bundle: nil)
        pomodoro.taskItem = taskItem
        navigationController?.pushViewController(pomodoro, animated: true)
    }
    
    @IBAction func deleteClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        let nav = UIApplication.sharedApplication().delegate?.window??.rootViewController as UINavigationController
        let tableViewController = nav.visibleViewController as TodayListController
        // TODO: id
        tableViewController.deleteTask(self.taskItem!.type.integerValue)
    }

    @IBAction func planTimeChanged(sender: AnyObject) {
        if taskItem!.isCompleted {
            return
        }
        let picker = sender as UIDatePicker
        taskItem?.startTime = picker.date
        let formater = NSDateFormatter()
        formater.dateFormat = "HH:mm aa"
        let text = "Start the task at \(formater.stringFromDate(picker.date))"
        
        let attrString = NSMutableAttributedString(string: text)
        var attrs = [NSForegroundColorAttributeName: UIColor.brownColor()]
        attrString.setAttributes(attrs, range: NSMakeRange(18, 8))
        labelPlan.attributedText = attrString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Collection data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.darkGrayColor()
        var thumb = UIImageView(frame: cell.contentView.frame)
        thumb.image = UIImage(named: (indexPath.row < taskItem!.estimated.integerValue ? "ic_checked_normal.png" : "ic_unchcked_normal.png"))
        thumb.clipsToBounds = true
        cell.contentView.addSubview(thumb)
        return cell
    }
    
    // MARK: - Collection delegate
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if taskItem!.isCompleted {
            let alert = UIAlertView()
            alert.title = "Notification"
            alert.message = "The task is already completed. You do not need to estimate it anymore. ^_^"
            alert.addButtonWithTitle("Okay")
            alert.show()
            return
        }
        taskItem!.estimated = indexPath.row + 1
        collectionView.reloadData()
    }
    
    // MARK: - Collection layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(1.1)
    }
}
