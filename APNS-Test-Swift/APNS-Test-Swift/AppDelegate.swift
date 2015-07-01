//
//  AppDelegate.swift
//  APNS-Test-Swift
//
//  Created by 구범모 on 2015. 6. 30..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Check if application started with a notification
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
            println("Started application with a remote notification: \(userInfo).")
        }
        
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? [NSObject: AnyObject] {
            println("Started application with a local notification: \(userInfo).")
        }
        
        // Register notification
        registerForNotifications()
        
        return true
    }
    
    // MARK: Register for notification
    private func registerForNotifications() {
        let categories = categoriesForInteractiveNotifications()
        let settings = UIUserNotificationSettings(forTypes: (.Alert | .Sound | .Badge), categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        println("Registered user notificaitons.")
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
        println("Registered remote notifications with token: \(token).")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed to register remote notifications with error: \(error).")
    }
    
    private enum NotificationAction: String {
        case Accept = "accept_id"
        case Decline = "decline_id"
        case Archive = "archive_id"
        case Delete = "delete_id"
        
        var title: String {
            switch self {
            case .Accept: return "Accept"
            case .Decline: return "Decline"
            case .Archive: return "Archive"
            case .Delete: return "Delete"
            }
        }
    }
    
    private func categoriesForInteractiveNotifications() -> Set<NSObject> {
        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.identifier = NotificationAction.Accept.rawValue
        acceptAction.title = NotificationAction.Accept.title
        acceptAction.activationMode = .Background
        
        let declineAction = UIMutableUserNotificationAction()
        declineAction.identifier = NotificationAction.Decline.rawValue
        declineAction.title = NotificationAction.Decline.title
        declineAction.destructive = true
        declineAction.activationMode = .Background
        
        let invitationCategory = UIMutableUserNotificationCategory()
        invitationCategory.identifier = "invitation_id"
        invitationCategory.setActions([acceptAction, declineAction], forContext: .Default)
        invitationCategory.setActions([acceptAction, declineAction], forContext: .Minimal)
        
        let archiveAction = UIMutableUserNotificationAction()
        archiveAction.identifier = NotificationAction.Archive.rawValue
        archiveAction.title = NotificationAction.Archive.title
        archiveAction.activationMode = .Background
        
        let deleteAction = UIMutableUserNotificationAction()
        deleteAction.identifier = NotificationAction.Delete.rawValue
        deleteAction.title = NotificationAction.Delete.title
        deleteAction.destructive = true
        deleteAction.activationMode = .Foreground
        
        let managementCategory = UIMutableUserNotificationCategory()
        managementCategory.identifier = "mangement_id"
        managementCategory.setActions([archiveAction, deleteAction], forContext: .Default)
        managementCategory.setActions([archiveAction, deleteAction], forContext: .Minimal)
        
        var categories = Set<NSObject>()
        categories.insert(invitationCategory)
        categories.insert(managementCategory)
        return categories
    }
    
    // MARK: Received local notifications
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("Received a local notification: \(notification.userInfo)")
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        println("Received a local notification with action: \(notification.userInfo)")
        
        // Handle action
        if let identifier = identifier {
            if let action = NotificationAction(rawValue: identifier) {
                println("Handling action \(action.title).")
                switch action {
                case .Accept: break
                case .Decline: break
                case .Archive: break
                case .Delete: break
                default: break
                }
            }
        }
    }
    
    // MARK: Received remote notifications
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Received a remote notification: \(userInfo)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("Received a remote notification with completion handler: \(userInfo)")
        completionHandler(.NoData)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        println("Received a remote notification with action: \(userInfo)")
        
        // Handle action
        if let identifier = identifier {
            if let action = NotificationAction(rawValue: identifier) {
                println("Handling action \(action.title).")
                switch action {
                case .Accept: break
                case .Decline: break
                case .Archive: break
                case .Delete: break
                default: break
                }
            }
        }
    }
}

