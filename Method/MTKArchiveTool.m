//
//  MTKArchiveTool.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/23.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKArchiveTool.h"
/*用户登录归档文件 */
#define MTKAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
@implementation MTKArchiveTool
+ (void)saveUser:(MTKUserInfo *)userInfo{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:MTKAccountFile];
}

+ (MTKUserInfo *)getUserInfo{
    // 取出账号
    MTKUserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MTKAccountFile];
    return account;
}
@end

