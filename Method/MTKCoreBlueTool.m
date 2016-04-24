//
//  MTKCoreBlueTool.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/23.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKCoreBlueTool.h"
#import "ScannedPeripheral.h"

const static int SCAN_DEVICE_TIMEOUT = 20;
@interface MTKCoreBlueTool ()
{
    NSMutableArray *peripherals;
}
@end

@implementation MTKCoreBlueTool

@synthesize mManager,mProService;

static MTKCoreBlueTool *instance;
+ (MTKCoreBlueTool *)sharedInstance{
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[MTKCoreBlueTool alloc] init];
        [instance initilize];
    });
    return instance;
}

- (void)initilize{
    mManager = [MTKBleManager sharedInstance];
    [mManager registerDiscoveryDelgegate:self];
    [mManager registerBluetoothStateChangeDelegate:self];
    [mManager registerConnectDelgegate:self];
    [mManager registerScanningStateChangeDelegate:self];
    
    mProService = [MTKBleProximityService getInstance];
    [mProService registerProximityDelgegate:self];
}
-(void)dealloc
{
    [mManager unRegisterDiscoveryDelgegate:self];
    [mManager unRegisterBluetoothStateChangeDelegate:self];
    [mManager unRegisterConnectDelgegate:self];
    [mManager unRegisterBluetoothStateChangeDelegate:self];
    [mProService unRegisterProximityDelgegate:self];
}

//开始搜索
- (void) MTKStartScan:(BOOL)timeOut{
    [mManager startScanning];
    if(timeOut == YES)
    {
        self.mScanTimerStarted = YES;
        [self performSelector:@selector(timeoutToStopScan) withObject:nil afterDelay:SCAN_DEVICE_TIMEOUT];
    }
}

//停止搜索
-(void) MTKStopScan
{
    [mManager stopScanning];
    if(self.mScanTimerStarted == YES)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutToStopScan) object:nil];
        self.mScanTimerStarted = NO;
    }
}

//忘记设备
- (void)forgetPeripheral{
    [mManager forgetPeripheral];
}

//断开连接
- (void)disConnectWithPeripheral{
    [mManager disconnectPeripheral:self.peripheral];
}

-(void)timeoutToStopScan
{
    self.mScanTimerStarted = NO;
    [self MTKStopScan];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutToStopScan) object:nil];
}

//查看蓝牙状态
-(BOOL)checkBleStatus{
    MTKUserInfo *user = [MTKArchiveTool getUserInfo];
    if (!user.userUUID || [user.userUUID isEqualToString:@""]) {
        [MBProgressHUD showError:MtkLocalizedString(@"alert_nobang")];
         return NO;
    }
    else if (self.peripheral.state != CBPeripheralStateConnected){
        [MBProgressHUD showError:MtkLocalizedString(@"alert_confirst")];
        return NO;
    }
    return YES;
}

#pragma mrk *******BleDiscoveryDelegate
- (void) discoveryDidRefresh: (CBPeripheral *)peripheral{
    NSLog(@"***** BleDiscoveryDelegate: **discoveryDidRefresh:%@**",peripheral);
    if ([peripheral.name isEqualToString:@"K88H"] ) {
        [mManager connectPeripheral:peripheral];
        [self MTKStopScan];
        if (self.delegate && [self.delegate respondsToSelector:@selector(MTKBLConnecting)]) {
            [self.delegate MTKBLConnecting];
        }
    }
}

- (void) discoveryStatePoweredOff{
     NSLog(@"***** BleDiscoveryDelegate: **discoveryStatePoweredOff**");
}

#pragma mark *****BluetoothAdapterStateChangeDelegate
-(void) onBluetoothStateChange:(int)state{
     NSLog(@"***** BluetoothAdapterStateChangeDelegate: **onBluetoothStateChange:%d**",state);
}

#pragma mark *****BleConnectDlegate
- (void) connectDidRefresh:(int)connectionState deviceName:(CBPeripheral*)peripheral{
    NSLog(@"***** BleConnectDlegate: connectDidRefresh: %d deviceName:%@",connectionState,peripheral);
    if (connectionState == 2) {
           MTKBleMgr.peripheral = peripheral;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(MTKBLConnectFinish:Peripheral:)]) {
        [self.delegate MTKBLConnectFinish:connectionState Peripheral:peripheral];
    }
}
- (void) disconnectDidRefresh: (int)connectionState devicename: (CBPeripheral *)peripheral{
    NSLog(@"***** BleConnectDlegate: disconnectDidRefresh: %d devicename:%@",connectionState,peripheral);
}
- (void) retrieveDidRefresh: (NSArray *)peripherals{
    NSLog(@"***** BleConnectDlegate: retrieveDidRefresh: %@",peripherals);
}

#pragma mark *****BleScanningStateChangeDelegate
- (void) scanStateChange:(int)state{
    NSLog(@"***** BleScanningStateChangeDelegate: scanStateChange: %d",state);
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
