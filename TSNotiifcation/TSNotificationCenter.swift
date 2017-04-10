//
//  TSNotificationCenter.swift
//  TSNotificationCenter
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

class TSNotificationCenter: NSObject {

    static let defaultCenter = TSNotificationCenter()
    var listeners:[TSNotificationObserver]?
    var notificationsPosted:[TSNotification]?

    override init() {
        super.init()
    }
    
  //MARK:Use this for posting notification
    func postTSNotification(notificationName:String?, withObject:AnyObject?, notificationFireType:NotificationFireType?){
        //Add object to a queue with name as a identifier for that object

        guard let notificationName = notificationName else{
            return
        }
        
        if notificationsPosted == nil {
            notificationsPosted = [TSNotification]()
        }
        
        let notificationPosterObject = TSNotification(name: notificationName, payload: withObject, notificationFireType: notificationFireType)
        
        //Check and remove other similar objects
        
        if let notificationsPosted = notificationsPosted {
            for (index,obj) in notificationsPosted.enumerated(){
                if obj.name == notificationPosterObject.name{
                    self.notificationsPosted?.remove(at: index)
                }
            }
        }
        
        notificationsPosted?.append(notificationPosterObject)
        self.runTSNotificationDispatcher(forPostedNotification: notificationPosterObject)
    }
    
    //MARK:Use this for adding observer for notification
    func addObserver(notificationName:String, observer:NSObject,selector:Selector){
        if listeners == nil {
            listeners = [TSNotificationObserver]()
        }
        
        //Added to the queue
        let messageObject = TSNotificationObserver(name: notificationName, observer: observer, selector: selector)
        self.listeners?.append(messageObject)
        
        self.runTSNotificationDispatcher(newObserver: messageObject)
       
    }
    
    //MARK:Adding an observer safely. Guards against reobserving
    func addObserverGuardAgainstReobserving(notificationName:String, observer:NSObject,selector:Selector) -> Bool{
        guard !isAnObserver(observer: observer) else {
            return false
        }
        if listeners == nil {
            listeners = [TSNotificationObserver]()
        }
        
        //Added to the queue
        let messageObject = TSNotificationObserver(name: notificationName, observer: observer, selector: selector)
        self.listeners?.append(messageObject)
        
        self.runTSNotificationDispatcher(newObserver: messageObject)
        return true
    }
    //MARK:Use this for removing observer for notification
    func removeNotification(notificationName:String) {
        
    }
    //MARK:Use this for removing observer for notification
    func removeObserver(observer:NSObject, name: String){
        guard let listenersForNotificationName = self.getListeners(notificationName: name) else {
            return
        }
        for notificationObserver in listenersForNotificationName {
            if notificationObserver.observer == observer {
                if let removalIndex = (self.listeners?.index(of: notificationObserver)) {
                    self.listeners?.remove(at: removalIndex)
                }
            }
        }
    }

    func removeObserver(observer:NSObject){
        guard let listenersForNotificationName = self.getListeners(notificationName: nil) else { //No need to send nil to get all notifications
            return
        }
        for notificationObserver in listenersForNotificationName {
            if notificationObserver.observer == observer { //**Can I compare nsobjects like this
                self.listeners?.remove(at: (self.listeners?.index(of: notificationObserver))!)
            }
        }
    }

    //MARK: Use this to find out whether an object is an observer
    func isAnObserver(observer:NSObject?) -> Bool {
        guard let observer = observer else {
            return false
        }
        guard let filteredListeners = self.listeners?.filter({
            return observer == $0.observer
        }) else {
            return false
        }
        return !filteredListeners.isEmpty
    }

    //MARK: Use this to find out whether listeners for a notification exists
    func hasObserver(notificationName:String?) -> Bool { //has observers
        guard let filteredListeners = self.listeners?.filter({
            return $0.name == notificationName
        }) else {
            return false
        }
        return !filteredListeners.isEmpty
    }
    
    //MARK: Use this to find out whether a particuar notification has been posted
    func hasGotNotificationForName(_ name:String) -> Bool {
        return self.notificationsPosted?.filter({
        let postedNotification:TSNotification = $0
            return postedNotification.name == name
        }) != nil
    }
    //MARK: This for returning all the objects listening to that particuar notification
    func getListeners(notificationName:String?) ->[TSNotificationObserver]?{
        guard let name = notificationName else {
            return listeners
        }
        //Searching for addresssees
        
        return listeners?.filter({
            let obj:TSNotificationObserver = $0
            return obj.name == name
        })
    }
    
    func remove(notification:TSNotification){
        guard let notificationsPosted = self.notificationsPosted else{
            return
        }
        //Check and remove posted notifications with name
        
        for (index,obj) in notificationsPosted.enumerated(){
            if obj == notification{
                self.notificationsPosted?.remove(at: index)
                break
            }
        }
    }
}


private extension TSNotificationCenter {
    //MARK: Dispatches messages to objects
    //Here resides all the firing mechanisms
    func runTSNotificationDispatcher(newObserver:TSNotificationObserver){
        guard let notificationsPosted = notificationsPosted else{
            return
        }
        for notification in notificationsPosted{
            if notification.name == newObserver.name{
                //Has a notification waiting for it
                if let selector = newObserver.selector {
                    _ = newObserver.observer?.perform(selector, with: notification)
                    notification.wasDispatched()
                    self.handleFutureOfNotification(notification)
                }
                break
            }
        }
    }
    
    func runTSNotificationDispatcher(forPostedNotification notification:TSNotification){
        //If some listener was found then remove from the posted notification list
        listeners?.forEach({
            let obj:TSNotificationObserver = $0
            if obj.name == notification.name{
                if let selector = obj.selector {
                    _ = obj.observer?.perform(selector, with: notification)
                    notification.wasDispatched()
                }
            }
        })
        self.handleFutureOfNotification(notification)
    }

    func handleFutureOfNotification(_ notification:TSNotification) {
        if notification.shouldRemoveFromQueue() {
            self.remove(notification: notification)
        }
    }
    
    func removeObserver(observerName:String?){
        guard let _ = observerName,
        let listeners = listeners else{
            return
        }
        
        for (index,obj) in listeners.enumerated(){
            if obj.name == observerName{
                notificationsPosted?.remove(at: index)
                break
            }
        }
        //Remove the notfication with the name from the present transmitters
    }
}
