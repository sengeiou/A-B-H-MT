//
//  MTKDefaultinfos.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FIRSTLUN @"FIRSTLUN"//首次打开软件
@interface MTKDefaultinfos : NSObject
+(void)putKey:(NSString *)key andValue:(NSObject *)value;
+(void)putInt:(NSString *)key andValue:(int)value;
+(NSString *)getValueforKey:(NSString *)key;
+(int)getIntValueforKey:(NSString *)key;
+ (void)removeValueForKey:(NSString *)key;
@end
