//
//  PomodoroViewController.swift
//  NotTomorrow
//
//  Created by Alex Hilton on 11/30/14.
//  Copyright (c) 2014 Alex Hilton. All rights reserved.
//

import UIKit

class PomodoroViewController: UIViewController {
    var taskItem: NTTaskItem?
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var buttonPause: UIButton!
    @IBOutlet weak var labelCountDown: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPomodoroNumber: UILabel!
    
    var pomodoroClockTimer: PomodoroTimer?
    var lastPomodoroClock = 60 * 25 // 25 minutes
    var pausing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelDescription.text = taskItem!.description
        
        // if task is already completed, disable all buttons and timers
        if taskItem!.completed! {
            buttonCancel.enabled = false
            buttonDone.enabled = false
            buttonPause.enabled = false
            labelType.text = "Rest time."
        } else {
            labelType.text = "Work time:"
            labelCountDown.text = ""
        }
        labelPomodoroNumber.text = "Pomodoro #\(taskItem!.consumed! + 1)"
        pausing = false
    }

    override func viewWillAppear(animated: Bool) {
        pomodoroClockTimer = PomodoroTimer(label: labelCountDown, initCount: lastPomodoroClock) {
            self.taskItem!.consumed! += 1
            self.labelType.text = "Rest time."
        }
        pomodoroClockTimer!.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        pomodoroClockTimer!.cancel()
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func taskDoneClicked(sender: AnyObject) {
        pomodoroClockTimer!.cancel()
        taskItem!.completed = true
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pauseClicked(sender: AnyObject) {
        if !pausing! {
            lastPomodoroClock = pomodoroClockTimer!.currentPomodoroClock!
            pomodoroClockTimer?.cancel()
            buttonPause.setTitle("Resume", forState: UIControlState.Normal)
            pausing = true
        } else {
            pomodoroClockTimer = PomodoroTimer(label: labelCountDown, initCount: lastPomodoroClock) {
                self.taskItem!.consumed! += 1
                self.labelType.text = "Rest time."
            }
            pomodoroClockTimer?.start()
            buttonPause.setTitle("Pause", forState: UIControlState.Normal)
            pausing = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    class PomodoroTimer: NSThread {
        var label: UILabel?
        var acallback: ()-> Void
        var currentPomodoroClock: Int?
        
        init(label: UILabel, initCount: Int, callback: () -> Void) {
            self.label = label
            self.acallback = callback
            self.currentPomodoroClock = initCount
            super.init()
            name = "PomodoroTimer"
        }
        
        override func main() {
            while currentPomodoroClock > 0 {
                if cancelled {
                    break
                }
                // sleep for 1 second
                NSThread.sleepForTimeInterval(1.0)
                if cancelled {
                    break
                }
                let sec = String(format: "%02d", currentPomodoroClock! % 60)
                let min = String(format: "%02d", currentPomodoroClock! / 60)
                dispatch_async(dispatch_get_main_queue()) {
                    self.label!.text = "\(min):\(sec)"
                }
                currentPomodoroClock!--
            }
            if !cancelled {
                acallback()
            }
        }
    }
    
}
