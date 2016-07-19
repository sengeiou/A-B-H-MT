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
#import "HealthKitManager.h"
@interface MtkAppDelegate ()
@property (nonatomic, strong)HKHealthStore *healthStore;
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
    NSLog(@"firstlun***8%@",firLun);
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
//        [[HealthKitManager healthkitMgrInstance] requestAuthorization];
}
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([HKHealthStore isHealthDataAvailable]) {
            self.healthStore = [[HKHealthStore alloc] init];
            NSSet *writeDataTypes = [self dataTypesToWrite];
            //        NSSet *readDataTypes = [self dataTypesToRead];
            [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:nil completion:^(BOOL success, NSError *error) {
                
                if (!success) {
                    NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                    return;
                }
            }];
        }
    }
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationHKHealthStore) name:@"HKHealthNot" object:nil];
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

- (NSSet *)dataTypesToWrite {
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *heartRateType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    return [NSSet setWithObjects:stepCountType,heartRateType,  nil];
}

-(void)NotificationHKHealthStore{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    MTKSqliteData *dal = [[MTKSqliteData alloc]init];
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    NSMutableArray *spoArr = [dal scarchSportWitchDate:[formatter1 stringFromDate:[NSDate date]] toDate:[formatter1 stringFromDate:[NSDate date]] UserID:[MTKArchiveTool getUserInfo].userID index:0];
    
    NSMutableArray *heartArr = [dal scarchHeartWitchDate:[formatter1 stringFromDate:[NSDate date]] toDate:[formatter1 stringFromDate:[NSDate date]] Userid:[MTKArchiveTool getUserInfo].userID];

    
    int lasStep = [MTKDefaultinfos getIntValueforKey:SENDHEALTHSTEP];
    int HeStep = 0;
    int heartRate = 0;
    if ([MTKDefaultinfos getValueforKey:HEALTHDAY] && [[MTKDefaultinfos getValueforKey:HEALTHDAY] isEqualToString:[fmt stringFromDate:[NSDate date]]]) {
        if ([[[spoArr lastObject] objectForKey:@"STEP"] intValue] > lasStep) {
            HeStep = [[[spoArr lastObject] objectForKey:@"STEP"] intValue] - lasStep;
        }
    }
    else{
        HeStep = [[[spoArr lastObject] objectForKey:@"STEP"] intValue];
    }

    if (heartArr.count>2) {
        heartRate = [heartArr[2] intValue];
    }

    //接入苹果健康
    //    define unit.
    NSString *unitIdentifier = HKQuantityTypeIdentifierStepCount;
    NSString *unitHRIdentifier = HKQuantityTypeIdentifierHeartRate;
    
    //define quantityType.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        HKQuantityType *quantityTypeIdentifier = [HKObjectType quantityTypeForIdentifier:unitIdentifier];
        HKQuantityType *quantityHRTypeIdentifier = [HKObjectType quantityTypeForIdentifier:unitHRIdentifier];
        
        //init quantity.
        HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:HeStep];
        
        //心率单位
        HKUnit *bpm = [HKUnit unitFromString:@"count/min"];
        
        HKQuantity *HRquantity = [HKQuantity quantityWithUnit:bpm doubleValue:heartRate];
        
        //init quantity sample.
        HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType:quantityTypeIdentifier quantity:quantity startDate:[NSDate date] endDate:[NSDate date] metadata:nil];
        
        HKQuantitySample *temperatureHRSample = [HKQuantitySample quantitySampleWithType:quantityHRTypeIdentifier quantity:HRquantity startDate:[NSDate date] endDate:[NSDate date] metadata:nil];
        //init store object.
        HKHealthStore *store = [[HKHealthStore alloc] init];
        
        //save.
        [store saveObjects:@[temperatureSample,temperatureHRSample] withCompletion:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"写入Helath成功==%@  step=%d",temperatureSample,HeStep);
            }else {
                NSLog(@"写入Helath失败==%@",error);
            }
        }];
    }
    [MTKDefaultinfos putKey:HEALTHDAY andValue:[fmt stringFromDate:[NSDate date]]];
    [MTKDefaultinfos putInt:SENDHEALTHSTEP andValue:[[[spoArr lastObject] objectForKey:@"STEP"] intValue]];
}
@end
