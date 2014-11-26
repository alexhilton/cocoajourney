//
//  TaskDetailViewController.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/23/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var taskItem: NTTaskItem?
    
    @IBOutlet weak var estimatedPomodoros: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var markCompleted: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Task details"
        setupLabel()
        estimatedPomodoros.backgroundColor = UIColor.whiteColor()
        estimatedPomodoros.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        estimatedPomodoros.delegate = self
        estimatedPomodoros.dataSource = self
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

    // MARK: - Collection data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.darkGrayColor()
        var thumb = UIImageView(frame: cell.contentView.frame)
        thumb.image = UIImage(named: (indexPath.row < taskItem?.estimated ? "ic_checked_normal.png" : "ic_unchcked_normal.png"))
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
        if taskItem!.completed! {
            let alert = UIAlertView()
            alert.title = "Notification"
            alert.message = "The task is already completed. You do not need to estimate it anymore. ^_^"
            alert.addButtonWithTitle("Okay")
            alert.show()
            return
        }
        taskItem?.estimated = indexPath.row + 1
        collectionView.reloadData()
    }
    
    // MARK: - Collection layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(1.1)
    }
}
