//
//  MTKSqliteDate.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/26.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTKSqliteData : NSObject
//插入运动数据
- (void)inserSportDateWithUser:(NSString *)userID WebId:(NSString *)webid Date:(NSString *)date Time:(NSString *)time Step:(NSString *)step Distance:(NSString *)dis Calory:(NSString *)cal Web:(NSString *)web callBack:(void(^)(BOOL result))callBack;
//查找某时间段运动数据
- (NSMutableArray *)scarchSportWitchDate:(NSString *)date toDate:(NSString *)date1 UserID:(NSString *)userid index:(int)dex;
//插入睡眠数据
- (void)inserSleepDataWithUser:(NSString *)userID WebId:(NSString *)webid Date:(NSString *)date Time:(NSString *)time Step:(NSString *)step Quality:(NSString *)quality Web:(NSString *)web callBack:(void(^)(BOOL result))callBack;
//查找某天睡眠数据
- (NSMutableArray *)scarchSleepWitchDate:(NSString *)date Userid:(NSString *)userid;
//插入心率数据
- (void)inserHeartDataWithUser:(NSString *)userId webID:(NSString *)webid Date:(NSString *)date Time:(NSString *)time HeartRate:(NSString *)heart Continuous:(NSString *)conti Web:(NSString *)web callBack:(void(^)(BOOL result))callback;
//查找某天心率数据
- (NSMutableArray *)scarchHeartWitchDate:(NSString *)date toDate:(NSString *)date1 Userid:(NSString *)userid;
@end
