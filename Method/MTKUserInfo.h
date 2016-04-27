//
//  MTKUserInfo.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/23.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTKUserInfo : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userPass;
@property (nonatomic, strong) NSString *userWeigh;
@property (nonatomic, strong) NSString *userHeight;
@property (nonatomic, strong) NSString *userGoal;
@property (nonatomic, strong) NSString *userBLName;
@property (nonatomic, strong) NSString *userBLVersion;
@property (nonatomic, strong) NSString *userUUID;
@property (nonatomic, strong) NSNumber *userAlEnable;
@property (nonatomic, strong) NSNumber *userRange;
@property (nonatomic, strong) NSNumber *userRanType;
@property (nonatomic, strong) NSNumber *userDistance;
@property (nonatomic, strong) NSNumber *userDisconEna;
@end
