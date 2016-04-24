//
//  MTKProximiService.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/24.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKBleManager.h"
#import "MTKBleProximityService.h"
@interface MTKProximiService : NSObject<ProximityAlarmProtocol>
@property MTKBleManager* mManager;
+ (MTKProximiService *)defaultInstance;
@end
