//
//  AppDelegate.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2018/11/30.
//  Copyright © 2018 longrise. All rights reserved.
//

#import "AppDelegate.h"
#import "YCDownloadSession.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    //setup downloadsession
    [self setUpDownload];
    
    return YES;
}

- (void)setUpDownload {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    path = [path stringByAppendingPathComponent:@"download"];
    YCDConfig *config = [YCDConfig new];
    config.saveRootPath = path;
    config.uid = @"100006";//userId
    config.maxTaskCount = 3;
    config.taskCachekMode = YCDownloadTaskCacheModeKeep;
    config.launchAutoResumeDownload = true;
    [YCDownloadManager mgrWithConfig:config];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskFinishedNoti:) name:kDownloadTaskFinishedNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAllTaskFinished) name:kDownloadTaskAllFinishedNoti object:nil];
}

#pragma mark notificaton

//- (void)downloadAllTaskFinished{
//    [self localPushWithTitle:@"YCDownloadSession" detail:@"所有的下载任务已完成！"];
//}

- (void)downloadTaskFinishedNoti:(NSNotification *)noti{
    YCDownloadItem *item = noti.object;
    if (item) {
        NSString *detail = [NSString stringWithFormat:@"%@ 视频，已经下载完成！", @"测试"];
        [self localPushWithTitle:@"YCDownloadSession" detail:detail];
    }
}

#pragma mark local push

- (void)localPushWithTitle:(NSString *)title detail:(NSString *)body  {
    
    if (title.length == 0) return;
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    localNote.alertBody = body;
    localNote.alertAction = @"滑动来解锁";
    localNote.hasAction = NO;
    localNote.soundName = @"default";
    localNote.userInfo = @{@"type" : @1};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    [[YCDownloader downloader] addCompletionHandler:completionHandler identifier:identifier];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    NSLog(@"%s", __func__);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"%s", __func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s", __func__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    NSLog(@"%s", __func__);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    NSLog(@"%s", __func__);
}


@end
