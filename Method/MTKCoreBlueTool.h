//
//  MTKCoreBlueTool.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/23.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKBleManager.h"
#import "MTKBleProximityService.h"

@protocol MTKCoreBlueToolDelegate <NSObject>
@optional
//正在连接
- (void)MTKBLConnecting;
//连接成功
- (void)MTKBLConnectFinish:(int)state;
@end

@interface MTKCoreBlueTool : NSObject<BleDiscoveryDelegate,BleConnectDlegate,ProximityAlarmProtocol,BleScanningStateChangeDelegate,BluetoothAdapterStateChangeDelegate,ProximityAlarmProtocol,CalibrateProtocol>
@property (nonatomic, strong) MTKBleManager* mManager;
@property (nonatomic, strong) MTKBleProximityService *mProService;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, assign) BOOL mScanTimerStarted;
@property (nonatomic, weak) id<MTKCoreBlueToolDelegate> delegate;
+ (MTKCoreBlueTool *)sharedInstance;
//开始搜索
- (void) MTKStartScan:(BOOL)timeOut;
//停止搜索
-(void) MTKStopScan;
//忘记设备
- (void)forgetPeripheral;
@end
