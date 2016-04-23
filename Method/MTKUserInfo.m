//
//  MTKUserInfo.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/23.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKUserInfo.h"

@implementation MTKUserInfo
//归档
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.userWeigh forKey:@"userWeigh"];
    [encoder encodeObject:self.userHeight forKey:@"userHeight"];
    [encoder encodeObject:self.userGoal forKey:@"userGoal"];
    [encoder encodeObject:self.userUUID forKey:@"userUUID"];
    [encoder encodeObject:self.userAlEnable forKey:@"userAlEnable"];
    [encoder encodeObject:self.userRange forKey:@"userRange"];
    [encoder encodeObject:self.userRanType forKey:@"userRanType"];
    [encoder encodeObject:self.userDistance forKey:@"userDistance"];
    [encoder encodeObject:self.userDisconEna forKey:@"userDisconEna"];
}

//解档
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.userWeigh = [decoder decodeObjectForKey:@"userWeigh"];
        self.userHeight = [decoder decodeObjectForKey:@"userHeight"];
        self.userGoal = [decoder decodeObjectForKey:@"userGoal"];
        self.userAlEnable = [decoder decodeObjectForKey:@"userAlEnable"];
        self.userRange = [decoder decodeObjectForKey:@"userRange"];
        self.userRanType = [decoder decodeObjectForKey:@"userRanType"];
        self.userDistance = [decoder decodeObjectForKey:@"userDistance"];
        self.userDisconEna = [decoder decodeObjectForKey:@"userDisconEna"];
    }
    return self;
}
@end
