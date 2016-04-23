//
//  MTKArchiveTool.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/23.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKUserInfo.h"
@interface MTKArchiveTool : NSObject
//保存用户
+ (void)saveUser:(MTKUserInfo *)userInfo;
//获取用户
+ (MTKUserInfo *)getUserInfo;
@end
