//
//  ViewController2.swift
//  NotificationExperiments
//
//  Created by Singh,Manish on 4/9/17.
//  Copyright © 2017 Singh,Manish. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var payloadOutputLabel: UILabel!
    @IBOutlet weak var switchKillPersistant: UISwitch!
    @IBOutlet weak var observingStatusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observingStatusView.layer.cornerRadius = 10
        
        updateObservingStatus()
    }
    
    @IBAction func buttonClearClicked(_ sender: Any) {
        payloadOutputLabel.text = ""
    }
    
    @IBAction func buttonUnsafeRegisterClicked(_ sender: Any) {
        _ = PNotificationCenter.defaultCenter.addObserver(for:"experiment.notification", observer: self, selector:#selector(ViewController1.notificationReceived(notification:)))
        updateObservingStatus()
    }
    
    @IBAction func buttonUnregisterClicked(_ sender: Any) {
        PNotificationCenter.defaultCenter.removeObserver(observer: self)
        updateObservingStatus()
    }
    
    @IBAction func buttonRegisterClicked(_ sender: Any) {
        _ = PNotificationCenter.defaultCenter.addObserverGuardAgainstReObserving(notificationName:"experiment.notification", observer: self, selector:#selector(ViewController1.notificationReceived(notification:)))
        updateObservingStatus()
    }
    
    func notificationReceived(notification:PNotification) {
        print("Received notification viewcontroller 1")
        if switchKillPersistant.isOn {
            notification.forget()
        }
        guard let payload = notification.payload as? String else {
            payloadOutputLabel.text = "Payload not received"
            return
        }
        if let existingText = self.payloadOutputLabel.text {
            payloadOutputLabel.text = existingText + ", " + payload
        }
        else {
            payloadOutputLabel.text = payload
        }
    }
    
    func updateObservingStatus() {
        if PNotificationCenter.defaultCenter.isAnObserver(object: self) {
            observingStatusView.backgroundColor = UIColor.green
        }
        else {
            observingStatusView.backgroundColor = UIColor.red
        }
    }
}
