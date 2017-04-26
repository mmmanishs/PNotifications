# NotificationExperiment

Post a notification

1. Fire and forget: This works as the iOS default NotificationCenter. Post a notification and it will be received by the observers to that notification is there are any.
TSNotificationCenter.defaultCenter.postTSNotification(notificationName:"experiment.notification",
withObject: "somePayloadString" as AnyObject?,
notificationFireType: NotificationFireType.notificationFireAndForget)

2. Fire and remember once if not intercepted: Fire this notification and it will get delivered if it has observers. If the notification does not have a observer then it will wait until an object observes it, and then get delivered to it. It will get delivered to the first object that observes it in the previous scenerio.
TSNotificationCenter.defaultCenter.postTSNotification(notificationName:"experiment.notification",
withObject: "somePayloadString" as AnyObject?,
notificationFireType: NotificationFireType.notificationFireAndRememberOnceIfNotIntercepted)

3. Fire and persist: Fire this notification and it will get delivered if it has observers. Any object observing this notification in the future will get this notification, until the notification is explicitally forgotten. If an new notification with the same name gets posted it will override the previous notification with the same name.

TSNotificationCenter.defaultCenter.postTSNotification(notificationName:"experiment.notification",
withObject: "somePayloadString" as AnyObject?,
notificationFireType: NotificationFireType.notificationFireAndPersist)


Adding an Observer to a notification

TSNotificationCenter.defaultCenter.addObserver(notificationName:"experiment.notification", observer: self, selector:#selector(SomeObject.someMethod(notification:)))

Adding an Observer to a notification safely
The object is added to the PNotificationCenter only once. This  method guards you against repeatedly registering "SomeObject" to that particular notification
Returns true if added successfully.
Returns false if it didnot add because the object was already an observer
_ = TSNotificationCenter.defaultCenter.addObserverGuardAgainstReobserving(notificationName:"experiment.notification",
    observer: self, 
    selector:#selector(ViewController1.notificationReceived(notification:)))

 

func notificationReceived(notification:TSNotification) {
    notification.forget //Forget a Fire and persist notification this way
}


Threading concerns
