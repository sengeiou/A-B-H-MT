//
//  AppDelegate.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MtkAppDelegate.h"
#import "ViewController.h"
#import "SmaNavMyInfoController.h"
@interface MtkAppDelegate ()

@end

@implementation MtkAppDelegate
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //ableCloud初始化
    [ACloudLib setMode:TEST_MODE Region:REGIONAL_CHINA];//指定地区及开发环境（测试或正式）
    [ACloudLib setMajorDomain:@"lijunhu" majorDomainId:282];//指定主域
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//    [MTKDefaultinfos removeValueForKey:FIRSTLUN];
      NSString *firLun = [MTKDefaultinfos getValueforKey:FIRSTLUN];
    if (!firLun || [firLun isEqualToString:@""]) {
        SmaNavMyInfoController *first = [[SmaNavMyInfoController alloc] initWithNibName:@"SmaNavMyInfoController" bundle:nil];
//        ViewController *first = [[ViewController alloc] init];
        MTKNavViewController *nav = [[MTKNavViewController alloc] initWithRootViewController:first];
        self.window.rootViewController = nav;
    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    else{
    MTKTabBarViewController *tabVC = [[MTKTabBarViewController alloc] init];
    self.window.rootViewController = tabVC;
}
    [UIApplication sharedApplication].statusBarHidden=NO;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)saveContext
{
    NSError* error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context != nil)
    {
        if ([context hasChanges] && ![context save: &error])
        {
            NSLog(@"[BLEAppDelegate] [saveContext] %@, %@ ", error, [error userInfo]);
            abort();
        }
    }
}

-(NSManagedObjectContext*)managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator* corr = [self persistentStoreCoordinator];
    if (corr != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:corr];
    }
    return managedObjectContext;
}

-(NSManagedObjectModel*)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:@"BLEManagerModel" withExtension:@"momd"];
    //NSLog(@"init model12312 %@", modelUrl);
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    //NSLog(@"init model %@", managedObjectModel);
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    NSLog(@"persist coordinator enter");
    NSURL* url = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"BLEManagerModel.sqlite"];
    NSError* error = nil;
    //NSLog(@"persist coordinator %@", self.managedObjectModel);
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
    {
        NSLog(@"[BLEAppDelegate] %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

-(NSURL*)applicationDocumentDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
