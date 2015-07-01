//
//  AppDelegate.m
//  APNS-Test-ObjC
//
//  Created by 구범모 on 2015. 6. 30..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Check if application started with a notification
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSLog(@"Started application with a remote notification: %@.", launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]);
    }
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        NSLog(@"Started application with a local notification: %@.", launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]);
    }
    
    // Register notification
    [self registerForNotifications];
    
    return YES;
}

#pragma mark - Register for notification
- (void)registerForNotifications {
    NSSet *categories = [self categoriesForInteractiveNotifications];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge) categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"Registered user notifications.");
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Registered remote notifications with token: %@.", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register remtoe notifications with error: %@.", error);
}

typedef NS_ENUM(NSInteger, NotificationAction) {
    NotificationActionAccept,
    NotificationActionDecline,
    NotificationActionArchive,
    NotificationActionDelete
};

- (NSString *)identifierForNotificationAction:(NotificationAction)action {
    switch (action) {
        case NotificationActionAccept: return @"accept_id";
        case NotificationActionDecline: return @"decline_id";
        case NotificationActionArchive: return @"archive_id";
        case NotificationActionDelete: return @"delete_id";
    }
}

- (NSString *)titleForNotificationAction:(NotificationAction)action {
    switch (action) {
        case NotificationActionAccept: return @"Accept";
        case NotificationActionDecline: return @"Decline";
        case NotificationActionArchive: return @"Archive";
        case NotificationActionDelete: return @"Delete";
    }
}

- (NSSet *)categoriesForInteractiveNotifications {
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    [acceptAction setIdentifier:[self identifierForNotificationAction:NotificationActionAccept]];
    [acceptAction setTitle:[self titleForNotificationAction:NotificationActionAccept]];
    [acceptAction setActivationMode:UIUserNotificationActivationModeBackground];
    
    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    [declineAction setIdentifier:[self identifierForNotificationAction:NotificationActionDecline]];
    [declineAction setTitle:[self titleForNotificationAction:NotificationActionDecline]];
    [declineAction setDestructive:YES];
    [declineAction setActivationMode:UIUserNotificationActivationModeBackground];
    
    UIMutableUserNotificationCategory *invitationCategory = [[UIMutableUserNotificationCategory alloc] init];
    [invitationCategory setIdentifier:@"invitation_id"];
    [invitationCategory setActions:@[acceptAction, declineAction] forContext:UIUserNotificationActionContextDefault];
    [invitationCategory setActions:@[acceptAction, declineAction] forContext:UIUserNotificationActionContextMinimal];
    
    UIMutableUserNotificationAction *archiveAction = [[UIMutableUserNotificationAction alloc] init];
    [archiveAction setIdentifier:[self identifierForNotificationAction:NotificationActionArchive]];
    [archiveAction setTitle:[self titleForNotificationAction:NotificationActionArchive]];
    [archiveAction setActivationMode:UIUserNotificationActivationModeBackground];
    
    UIMutableUserNotificationAction *deleteAction = [[UIMutableUserNotificationAction alloc] init];
    [deleteAction setIdentifier:[self identifierForNotificationAction:NotificationActionDelete]];
    [deleteAction setTitle:[self titleForNotificationAction:NotificationActionDelete]];
    [deleteAction setDestructive:YES];
    [deleteAction setActivationMode:UIUserNotificationActivationModeForeground];
    
    UIMutableUserNotificationCategory *managementCategory = [[UIMutableUserNotificationCategory alloc] init];
    [managementCategory setIdentifier:@"management_id"];
    [managementCategory setActions:@[archiveAction, deleteAction] forContext:UIUserNotificationActionContextDefault];
    [managementCategory setActions:@[archiveAction, deleteAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:invitationCategory, managementCategory, nil];
    return categories;
}

#pragma mark - Received local notifications
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Received a local notification: %@", [notification userInfo]);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    NSLog(@"Received a local notification with action: %@", [notification userInfo]);
    
    // Handle action
    NSLog(@"Handling action %@.", identifier);
}

#pragma mark - Received remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received a remote notification: %@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Received a remote notification with completion handler: %@", userInfo);
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"Received a remote notification with action: %@", userInfo);
    
    // Handle action
    NSLog(@"Handling action %@.", identifier);
}

@end
