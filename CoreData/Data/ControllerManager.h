//
//  ControllerManager.h
//  Mediatek SmartDevice
//
//  Created by kct on 15/6/8.
//  Copyright (c) 2015年 Mediatek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Controller.h"

@interface ControllerManager : NSObject

+ (id) getControllerManagerInstance;

- (void)onReceive: (int)cmdType data: (NSData *)data;

-(void)addController:(Controller*)controller;
-(void)removeController:(Controller*)controller;
-(void)removeAllControllers;

-(void)onProgress: (float)sentPercent;

- (void)onConnectStateChange: (int)state;

@end

