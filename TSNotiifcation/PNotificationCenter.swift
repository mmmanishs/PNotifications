//
//  PNotificationCenter.swift
//  PNotificationCenter
//
//  Created by Singh,Manish on 1/13/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//


import UIKit
enum NotificationFireType{
    case notificationFireAndForget
    case notificationFireAndRememberOnceIfNotIntercepted
    case notificationFireAndPersist
}

class PNotificationCenter: NSObject {
    static let defaultCenter = PNotificationCenter()
    var observers = [PNotificationObserver]()
    var notificationsQueue = [PNotification]()
    
    //MARK:Use this for posting notification
    func post(notificationName:String,
              withObject:AnyObject?,
              notificationFireType:NotificationFireType) {
        
        //Add object to a queue with name as a identifier for that object
        let newNotification = PNotification(name: notificationName,
                                            payload: withObject,
                                            notificationFireType: notificationFireType)
        
        //Check and remove other similar objects
        notificationsQueue = notificationsQueue.filter { notification in
            return notification.name != newNotification.name
        }
        
        notificationsQueue.append(newNotification)
        PNotificationsDispatcher.dispatch(for : newNotification, observers: observers, notificationsQueue: &notificationsQueue)
    }
    
    //MARK:Use this for adding observer for notification
    func addObserver(for name: String, observer: NSObject, selector:Selector) {
        //Added to the queue
        let messageObject = PNotificationObserver(name: name, observer: observer, selector: selector)
        observers.append(messageObject)
        PNotificationsDispatcher.dispatch(newObserver: messageObject, notificationsQueue: &notificationsQueue)
    }
    
    //MARK:Adding an observer safely. Guards against reobserving
    func addObserverGuardAgainstReObserving(notificationName:String, observer:NSObject, selector:Selector) -> Bool {
        guard !isAnObserver(object: observer) else {
            return false
        }
        //Added to the queue
        let messageObject = PNotificationObserver(name: notificationName, observer: observer, selector: selector)
        observers.append(messageObject)
        PNotificationsDispatcher.dispatch(newObserver: messageObject, notificationsQueue: &notificationsQueue)
        return true
    }
    
    //MARK:Use this for removing observer for notification
    func removeNotification(notificationName:String) {
        notificationsQueue = notificationsQueue.filter { notification in
            return notification.name != notificationName
        }
    }
    
    //MARK:Use this for removing observer for notification
    func removeObserver(observer:NSObject, name: String) {
        observers = observers.filter { existingObserver in
            return (existingObserver.name == name) && (existingObserver.object != observer)
        }
    }
    
    //MARK: Use this to find out whether an object is an observer
    func isAnObserver(object: NSObject) -> Bool {
        let filteredObserver = observers.filter { existingObserver in
            return existingObserver.object.isEqual(object)
        }
        return filteredObserver.count != 0
    }
    
    func removeFromQueue(notification:PNotification){
        //Check and remove posted notifications with name
        if let index = notificationsQueue.index(of: notification) {
            notificationsQueue.remove(at: index)
        }
    }
    
    func removeObserver(observer: NSObject){
        observers = observers.filter { existingObserver in
            return existingObserver.object != observer
        }
    }
}


private extension PNotificationCenter {
    func handleFutureOfNotification(_ notification:PNotification) {
        if notification.shouldRemoveFromQueue() {
            removeFromQueue(notification: notification)
        }
    }
    
    func removeObserver(observerName:String) {
        observers = observers.filter { observer in
            return observer.name != observerName
        }
    }
}
