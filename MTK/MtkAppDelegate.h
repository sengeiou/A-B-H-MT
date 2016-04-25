//
//  AppDelegate.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MTKTabBarViewController.h"
@interface MtkAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MTKTabBarViewController *tabVC;
@property (readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

-(void)saveContext;
-(NSURL*) applicationDocumentDirectory;

@end

