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
- (NSMutableArray *)scarchSportWitchDate:(NSString *)date toDate:(NSString *)date1 UserID:(NSString *)userid;
@end
