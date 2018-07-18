//
//  PNotificationsDispatcher.swift
//  NotificationExperiments
//
//  Created by Manish Singh on 7/17/18.
//  Copyright © 2018 Singh,Manish. All rights reserved.
//

import Foundation

class PNotificationsDispatcher {
    static func runPNotificationDispatcher(newObserver:PNotificationObserver, notificationsQueue: inout [PNotification]) {
        for (index, notification) in notificationsQueue.enumerated() {
            if notification.name == newObserver.name {
                //Has a notification waiting for it
                newObserver.object.perform(newObserver.selector, with: notification)
                notification.wasDispatched()
                if notification.shouldRemoveFromQueue() {
                    notificationsQueue.remove(at: index)
                }
                break
            }
        }
    }
    
    static func runPNotificationDispatcher(forPostedNotification notification:PNotification, observers: [PNotificationObserver], notificationsQueue: inout [PNotification]){
        for observer in observers {
            if observer.name == notification.name {
                _ = observer.object.perform(observer.selector, with: notification)
                notification.wasDispatched()
            }
        }
        if notification.shouldRemoveFromQueue(),
            let index = notificationsQueue.index(of: notification) {
            notificationsQueue.remove(at: index)
        }
    }
}
