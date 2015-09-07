//
//  AppDelegate.m
//  PushIos
//
//  Created by jinlong.yang on 15-9-6.
//  Copyright (c) 2015年 com.qunar.ops.push. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
#ifdef __IPHONE_8_0
    NSLog(@"当前设备系统是ios8");
    // 注册远程推送通知(APP每次启动的时候)
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes: types
                                                                                         categories: nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings: notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
#else
    NSLog(@"当前设备系统是ios7");
    // 注册远程推送通知(APP每次启动的时候)
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeSound |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeBadge];
#endif
    
    // 点击推送通知，但程序没有启动时，推送消息存储在参数launchOptions里
    NSDictionary* userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"每次启动时，userInfo=== %@", userInfo);
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 注册成功，APNs返给你token，该方法被调用
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"获得token值为：%@", token);
}

#pragma mark - 注册失败，该方法被调用
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册失败，无法获取deviceToken，错误原因：%@", error);
}

#pragma mark - 点击接收推送过来的消息(分两种情况：app正在运行或者运行在后台)
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"接收到的推送消息为：%@", userInfo);
    
    if (application.applicationState == UIApplicationStateActive)
    {
        // 获得焦点,表明运行在前台
        NSLog(@"ypush application 运行在前台......");
        
        // 运行在前台,当来推送直接提示对话框展示
        NSString* pushTip = userInfo[@"aps"][@"alert"];
        NSLog(@"推送提示信息为： %@", pushTip);
        
        UIAlertView *alert =
        [[UIAlertView alloc ] initWithTitle : @"yPush"
                                    message : pushTip
                                   delegate : self
                          cancelButtonTitle : @"取消"
                          otherButtonTitles : @"查看", nil];
        [alert show ];
    }
    else if (application.applicationState == UIApplicationStateInactive)
    {
        // 失去焦点,表明运行在后台
        NSLog(@"ypush application 运行在后台......");
        
        // 运行在后台,点击后,直接进入详情界面显示
    }
}


#pragma mark - UIAlertViewDelegate 代理方法，获取点击按钮的索引并获取内容
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSLog(@"当前要查看推送内容.............");
        
        NSString* pushText = [alertView message];
        NSLog(@"推送内容为： %@", pushText);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
