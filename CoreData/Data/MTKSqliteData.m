//
//  MTKSqliteDate.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/26.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSqliteData.h"
#import "FMDB.h"

@interface MTKSqliteData ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation MTKSqliteData
-(FMDatabaseQueue *)createDataBase
{
    
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MTKSmartch.sqlite"];
    // 1.创建数据库队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filename];
    // 2.创表
    if(!_queue)
    {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL result = [db executeUpdate:@"CREATE TABLE if not exists MTKSport_tb (sport_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, web_id TEXT, date TEXT, time TEXT, step TEXT, distance TEXT, calory TEXT, sport_web TEXT)"];
            if (result) {
                NSLog(@"创表成功");
            } else {
                NSLog(@"创表失败");
            }
             }];
        }
     return queue;
}

//懒加载
-(FMDatabaseQueue *)queue
{
    if(!_queue)
    {
        _queue= [self createDataBase];
    }
    return _queue;
}

//插入运动数据
- (void)inserSportDateWithUser:(NSString *)userID WebId:(NSString *)webid Date:(NSString *)date Time:(NSString *)time Step:(NSString *)step Distance:(NSString *)dis Calory:(NSString *)cal Web:(NSString *)web callBack:(void(^)(BOOL result))callBack{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        NSString *deleQuery = [NSString stringWithFormat:@"delete from MTKSport_tb where time=\'%@\' and date=\'%@\' and user_id=\'%@\'",time,date,userID];
        BOOL result;
        result = [db executeUpdate:deleQuery];
        NSLog(@"**************************删除相同时刻运动数据  %d",result);
//        NSString *insertQuery = [NSString stringWithFormat:]
        result = [db executeUpdate:@"insert into MTKSport_tb (user_id,web_id,date,time,step,distance,calory,sport_web) values(?,?,?,?,?,?,?,?)",userID,webid,date,time,step,dis,cal,web];
        NSLog(@"**************************插入运动数据  %d",result);
        [db commit];
        callBack(result);
    }];
}

//查找某时间段运动数据
- (NSMutableArray *)scarchSportWitchDate:(NSString *)date toDate:(NSString *)date1 UserID:(NSString *)userid{
    NSMutableArray *sportArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *selStr = [NSString stringWithFormat:@"select *from MTKSport_tb where date>=\'%@\' and date<=\'%@\' and user_id=\'%@\'",date,date1,userid];
        FMResultSet *rs = [db executeQuery:selStr];
        NSString *sportC;
        NSString *sportD;
        NSString *sportS;
        while (rs.next) {
            sportD = [rs stringForColumn:@"distance"];
            sportC = [rs stringForColumn:@"calory"];
            sportS = [rs stringForColumn:@"step"];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:sportS,@"STEP",sportD,@"DISTANCE",sportC,@"CAL", nil];
            [sportArr addObject:dic];
        }
    }];
    return sportArr;
}
@end
