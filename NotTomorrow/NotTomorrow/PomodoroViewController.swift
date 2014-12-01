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
    
    var pomodoroClockTimer: PomodoroTimer?
    
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
            labelCountDown.text = "25:00"
        }
    }

    override func viewWillAppear(animated: Bool) {
        pomodoroClockTimer = PomodoroTimer(label: labelCountDown)
        pomodoroClockTimer!.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        pomodoroClockTimer!.cancel()
    }

    @IBAction func taskDoneClicked(sender: AnyObject) {
    }
    
    @IBAction func pauseClicked(sender: AnyObject) {
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
        var currentPomodoroClock = 25*60
        var label: UILabel?
        
        init(label: UILabel) {
            super.init()
            name = "PomodoroTimer"
            self.label = label
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
                let sec = String(format: "%02d", currentPomodoroClock % 60)
                let min = String(format: "%02d", currentPomodoroClock / 60)
                dispatch_async(dispatch_get_main_queue()) {
                    self.label!.text = "\(min):\(sec)"
                }
                currentPomodoroClock--
            }
        }
    }
    
}
