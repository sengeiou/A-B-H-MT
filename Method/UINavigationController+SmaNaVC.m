//
//  UINavigationController+SmaNaVC.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "UINavigationController+SmaNaVC.h"

#import <objc/runtime.h>
static char const *const kNavigationControllerKey_PushPop = "kNC_PushPop";
@implementation UINavigationController (SmaNaVC)
- (BOOL)isPushingOrPoping{
    NSNumber *number = objc_getAssociatedObject(self, kNavigationControllerKey_PushPop);
    return [number boolValue];
}

- (void)setIsPushingOrPoping:(BOOL)isPushingOrPoping{
    NSNumber *number = [NSNumber numberWithBool:isPushingOrPoping];
    objc_setAssociatedObject(self, kNavigationControllerKey_PushPop, number, OBJC_ASSOCIATION_RETAIN);
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSNumber *number = [NSNumber numberWithBool:NO];
    //        objc_setAssociatedObject(self, kNavigationControllerKey_PushPop, number, OBJC_ASSOCIATION_RETAIN);
    //    });
}
@end
