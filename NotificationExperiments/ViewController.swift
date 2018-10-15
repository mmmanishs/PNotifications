//
//  ViewController.swift
//  NotificationExperiments
//
//  Created by Singh,Manish on 4/9/17.
//  Copyright © 2017 Singh,Manish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonFireAndPersist(_ sender: Any) {
        PNotificationCenter.defaultCenter.post(notificationName:"experiment.notification", withObject: "FireAndPersist" as AnyObject?, notificationFireType: NotificationFireType.notificationFireAndPersist)
        
    }
    
    @IBAction func buttonFireAndForget(_ sender: Any) {
        PNotificationCenter.defaultCenter.post(notificationName:"experiment.notification", withObject: "FireAndForget" as AnyObject?, notificationFireType: NotificationFireType.notificationFireAndForget)
        
    }
    
    @IBAction func buttonFireAndRememberOnce(_ sender: Any) {
        PNotificationCenter.defaultCenter.post(notificationName:"experiment.notification",
                                               withObject: "FireAndRememberOnceIfNotIntercepted" as AnyObject?,
                                               notificationFireType: NotificationFireType.notificationFireAndRememberOnceIfNotIntercepted)
        
    }
}

