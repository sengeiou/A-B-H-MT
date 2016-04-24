//
//  MTKProximiService.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/24.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKProximiService.h"

@implementation MTKProximiService
@synthesize mManager;

static MTKProximiService *instance;
+ (MTKProximiService *)defaultInstance{
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[MTKProximiService alloc] init];
        [instance initDeviceState];
    });
    return instance;
}

-(void)initDeviceState{
    mManager = [MTKBleManager sharedInstance];
    [[MTKBleProximityService getInstance] registerProximityDelgegate: instance];
}

#pragma mark *****ProximityAlarmProtocol
- (void)distanceChangeAlarm: (CBPeripheral *)peripheral distance: (int)distanceValue{
        NSLog(@"***** ProximityAlarmProtocol: distanceChangeAlarm: %@ distance: %d",peripheral,distanceValue);
}

- (void)alertStatusChangeAlarm: (BOOL)alerted{
        NSLog(@"***** ProximityAlarmProtocol: alertStatusChangeAlarm: %d",alerted);
}
    
- (void)rssiReadBack: (CBPeripheral *)peripheral status: (int)status rssi: (int)rss{
        NSLog(@"***** ProximityAlarmProtocol: rssiReadBack: %@ status: %d rssi: %d",peripheral,status,rss);
}
@end
