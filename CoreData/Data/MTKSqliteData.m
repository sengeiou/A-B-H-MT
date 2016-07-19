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
            result = [db executeUpdate:@"CREATE TABLE if not exists MTKSleep_tb (sleep_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, web_id TEXT, date TEXT, time TEXT, sleep_time TEXT , step TEXT, quality TEXT, sleep_web TEXT)"];
            result = [db executeUpdate:@"CREATE TABLE if not exists MTKHeart_tb (heart_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, web_id TEXT, date TEXT, time TEXT, heart TEXT, continuous TEXT, heart_web TEXT)"];
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
        result = [db executeUpdate:@"insert into MTKSport_tb (user_id,web_id,date,time,step,distance,calory,sport_web) values(?,?,?,?,?,?,?,?)",userID,webid,date,time,step,dis,cal,web];
        NSLog(@"**************************插入运动数据  %d",result);
        [db commit];
        callBack(result);
    }];
}

//查找某时间段运动数据
- (NSMutableArray *)scarchSportWitchDate:(NSString *)date toDate:(NSString *)date1 UserID:(NSString *)userid index:(int)dex{
    NSMutableArray *sportArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *selStr;
        if (dex == 0) {
          selStr = [NSString stringWithFormat:@"select *from MTKSport_tb where date>=\'%@\' and date<=\'%@\' and user_id=\'%@\'",date,date1,userid];
        }
        else if(dex == 1) {
            selStr = [NSString stringWithFormat:@"select *from MTKSport_tb where date>=\'%@\' and date<=\'%@\' and user_id=\'%@\'",date,date1,userid];
        }
        else{
             selStr = [NSString stringWithFormat:@"select *from MTKSport_tb where date>=\'%@\' and date<\'%@\' and user_id=\'%@\' group by date",date,date1,userid];
        }
        FMResultSet *rs = [db executeQuery:selStr];
        NSString *sportC;
        NSString *sportD;
        NSString *sportS;
        NSString *sportTi;
        while (rs.next) {
            sportD = [rs stringForColumn:@"distance"];
            sportC = [rs stringForColumn:@"calory"];
            sportS = [rs stringForColumn:@"step"];
            sportTi = [rs stringForColumn:@"web_id"];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:sportS,@"STEP",sportD,@"DISTANCE",sportC,@"CAL",sportTi,@"TIME", nil];
            [sportArr addObject:dic];
        }
    }];
    return sportArr;
}

//插入睡眠数据
- (void)inserSleepDataWithUser:(NSString *)userID WebId:(NSString *)webid Date:(NSString *)date Time:(NSString *)time sleepTime:(NSString *)slTime Step:(NSString *)step Quality:(NSString *)quality Web:(NSString *)web callBack:(void(^)(BOOL result))callBack{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        NSString *delQuery = [NSString stringWithFormat:@"delete from MTKSleep_tb where web_id=\'%@\' and user_id=\'%@\'",webid,userID];
        BOOL result;
        result = [db executeUpdate:delQuery];
        NSLog(@"**************************删除相同时刻睡眠数据  %d",result);
        result = [db executeUpdate:@"insert into MTKSleep_tb (user_id,web_id,date,time,sleep_time,step,quality,sleep_web) values(?,?,?,?,?,?,?,?)",userID,webid,date,time,slTime,step,quality,web];
        NSLog(@"**************************插入睡眠数据  %d",result);
        [db commit];
        callBack(result);
    }];
}

//查找某天睡眠数据
- (NSMutableArray *)scarchSleepWitchDate:(NSString *)date Userid:(NSString *)userid{
    NSMutableArray *sleepArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *selStr = [NSString stringWithFormat:@"select *from MTKSleep_tb where date=\'%@\' and user_id=\'%@\'",date,userid];
        FMResultSet *rs = [db executeQuery:selStr];
        NSString *sleepT;
        NSString *sleepQ;
        NSString *sleepTI;
        while (rs.next) {
            sleepT = [NSString stringWithFormat:@"%ld",(long)[self returnSeconds:[rs stringForColumn:@"time"]]];
            sleepQ = [rs stringForColumn:@"quality"];
            sleepTI = [rs stringForColumn:@"sleep_time"];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sleepT,@"TIME",sleepTI,@"SLEEPTIME",sleepQ,@"QUALITY", nil];
            [sleepArr addObject:dic];
        }
    }];
    return sleepArr;
}



//插入心率数据
- (void)inserHeartDataWithUser:(NSString *)userId webID:(NSString *)webid Date:(NSString *)date Time:(NSString *)time HeartRate:(NSString *)heart Continuous:(NSString *)conti Web:(NSString *)web callBack:(void(^)(BOOL result))callback{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
       NSString *delQuery = [NSString stringWithFormat:@"delete from MTKHeart_tb where web_id=\'%@\' and user_id=\'%@\'",webid,userId];
        BOOL result;
        result = [db executeUpdate:delQuery];
        NSLog(@"**************************删除相同时刻心率数据  %d",result);
        result = [db executeUpdate:@"insert into MTKHeart_tb (user_id,web_id,date,time,heart,continuous,heart_web) values(?,?,?,?,?,?,?)",userId,webid,date,time,heart,conti,web];
        NSLog(@"**************************插入心率数据  %d",result);
        [db commit];
        callback(result);
    }];
}

//查找某天心率数据
- (NSMutableArray *)scarchHeartWitchDate:(NSString *)date toDate:(NSString *)date1 Userid:(NSString *)userid{
     NSMutableArray *heartArr = [NSMutableArray array];
    NSLog(@"slef=%@",self.queue);
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *selAvg = [NSString stringWithFormat:@"select avg(heart) as avgHR,max(heart) as maxHR from MTKHeart_tb where date>=\'%@\' and date<=\'%@\' and user_id=\'%@\' and heart>0",date,date1,userid];
        FMResultSet *rsAvg = [db executeQuery:selAvg];
        while (rsAvg.next) {
            NSString *groupHR;
            NSString *maxHR;
            
            groupHR =[rsAvg stringForColumn:@"avgHR"];
            maxHR =[rsAvg stringForColumn:@"maxHR"];
            if (groupHR) {
                  [heartArr addObject:groupHR];
            }
            if (maxHR) {
                  [heartArr addObject:maxHR];
            }
        }
        
        NSString *selStr = [NSString stringWithFormat:@"select *from MTKHeart_tb where date>=\'%@\' and date<=\'%@\' and user_id=\'%@\' order by heart_id desc limit 1",date,date1,userid];
        FMResultSet *rs = [db executeQuery:selStr];
        NSString *heartT;
        NSString *heartH;
        NSString *heartD;
        while (rs.next) {
            heartD = [rs stringForColumn:@"date"];
            heartT = [rs stringForColumn:@"time"];
            heartH = [rs stringForColumn:@"heart"];
            [heartArr addObject:heartH];
        }
    }];
    return heartArr;
}

//查找当天历史心率数据
- (NSMutableArray *)scarchHisHeartWitchDate:(NSString *)date  userID:(NSString *)userid{
    NSMutableArray *hisArr = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *selStr = [NSString stringWithFormat:@"select *from MTKHeart_tb where date=\'%@\' and user_id=\'%@\' order by heart_id desc ",date,userid];
        FMResultSet *rs = [db executeQuery:selStr];
        NSString *heartT;
        NSString *heartH;
        NSString *heartD;
        while (rs.next) {
            heartD = [rs stringForColumn:@"date"];
            heartT = [rs stringForColumn:@"time"];
            heartH = [rs stringForColumn:@"heart"];
            [hisArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:heartD,@"DATE",heartT,@"TIME",heartH,@"HEART", nil]];
        }
    }];
    return hisArr;
}

- (NSInteger)returnSeconds:(NSString *)time{
    
    return [[time substringToIndex:2] intValue]*3600 + [time substringWithRange:NSMakeRange(2, 2)].intValue*60 + [time substringFromIndex:4].intValue;
}
@end
